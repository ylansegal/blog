---
layout: post
title: "Redirecting To An External Server May Leak Tokens In Headers"
date: 2016-09-20 21:56:20 -0700
comments: true
categories:
- security
---

While working on an HTTP API that serves binary files to client applications, I came upon some unexpected behavior.

Imagine that we have a `/file/:id` endpoint, but that instead of responding with the binary, it redirects to an external storage service, like _AWS S3_. Our endpoint is also protected, so that users need an access token. A typical request/response cycle:

```
$ curl --include --header "Authorization: Bearer SECRET_TOKEN" http://localhost:3000/file/12345
HTTP/1.1 302 Found
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Location: https://external-file-server.com/some-path
Content-Type: text/html; charset=utf-8
Cache-Control: no-cache
X-Request-Id: 8025fbf8-8513-401b-8ebc-32752cfd7c59
X-Runtime: 0.002428
Transfer-Encoding: chunked

<html><body>You are being <a href="https://example.com/some-path">redirected</a>.</body></html>```
```

Now, let's instruct `curl` to follow redirects and be more verbose so that we can see the headers sent in the requests, as well as the responses. I'll omit some output (with `...`) for clarity.

```
$ curl --verbose --location --header "Authorization: Bearer SECRET_TOKEN" http://localhost:3000/file/12345
> GET /file/12345 HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.43.0
> Accept: */*
> Authorization: Bearer SECRET_TOKEN
>
< HTTP/1.1 302 Found
< X-Frame-Options: SAMEORIGIN
< X-XSS-Protection: 1; mode=block
< X-Content-Type-Options: nosniff
< Location: https://example.com/some-path
< Content-Type: text/html; charset=utf-8
< Cache-Control: no-cache
< X-Request-Id: 4c2254fb-d5a5-46d2-9a8b-9cbfecc8b2ec
< X-Runtime: 0.002537
< Transfer-Encoding: chunked
<

> GET /some-path HTTP/1.1
> Host: example.com
> User-Agent: curl/7.43.0
> Accept: */*
> Authorization: Bearer SECRET_TOKEN
>
< HTTP/1.1 404 Not Found
...
```

`curl`, as requested, followed the redirect response, but in doing so, it included the original `Authorization` header in the request to another domain[^1]. We have just leaked our secret and gave a valid token to access our system to a third party. To be fair, after some thought, I think it's reasonable for `curl` to interpret that the header is to be sent in *all* requests, since we are also telling it to follow redirects. From the manual:

> WARNING: headers set with this option will be set in all requests - even after redirects are  followed, like  when  told  with  -L,  --location. This can lead to the header being sent to other hosts than the original host, so sensitive headers should be used with caution combined with following redirects.

## Who does that?

`curl`'s behavior (sending specifically set headers on redirects) was also observed on some other User Agents, notably the library used by one of our client applications. However, it doesn't seem to be universal. For example [httpie][httpie], does not leak the header:

```
$ http --verbose --follow http://localhost:3000/file/12345 "Authorization: Bearer SECRET_TOKEN"
GET /file/12345 HTTP/1.1
Accept: */*
Accept-Encoding: gzip, deflate
Authorization: Bearer SECRET_TOKEN
Connection: keep-alive
Host: localhost:3000
User-Agent: HTTPie/0.9.6



HTTP/1.1 302 Found
Cache-Control: no-cache
Content-Type: text/html; charset=utf-8
Location: https://example.com/some-path
Transfer-Encoding: chunked
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
X-Request-Id: a53eb96b-f58c-4eb0-bbbd-bdca3eee8cc6
X-Runtime: 0.002384
X-XSS-Protection: 1; mode=block

GET /some-path HTTP/1.1
Accept: */*
Accept-Encoding: gzip, deflate
Connection: keep-alive
Host: example.com
User-Agent: HTTPie/0.9.6



HTTP/1.1 404 Not Found
...
```

As you can see, the `Authorization` header is conspicuous for its absence in the second request.

## Mitigation

Since we can't predict the behavior of all User Agents that are going to use our API, we can design our APIs differently on the server.

### Use Token As a Parameter

If we are using OAuth2 (which my example implies, because the use of a `Bearer` token), the specification allows for the token to be passed as a *URI Query Parameter* named `access_token`. Since that makes it part of the original URL it will certainly not be included by any client that follows redirection. However, I have seen the used flagged as risky by several security audits. One of the objections is that parameters in URLs are commonly written to logs and expose tokens unnecessarily.

The OAuth2 specification also allows a *Form-Encoded Body Parameter* also named `access_token`. This gets aournd the fact that the token is part of the URL and won't be sent on any redirect. However, the request must have an `application/x-www-form-urlencoded` content type, which may conflict with the rest of the application wanting it to be `application/json` or similar.

### Use Basic Authentication

Basic Authentication is a method for a User Agent to provide credentials to the server (usually username and password). Most User Agents have good support for it and understand that its use is limited to the original URL.

```
$ curl --verbose --location --user SECRET_TOKEN: http://localhost:3000/file/12345
> GET /file/12345 HTTP/1.1
> Host: localhost:3000
> Authorization: Basic U0VDUkVUX1RPS0VOOg==
> User-Agent: curl/7.43.0
> Accept: */*
>
< HTTP/1.1 302 Found
< X-Frame-Options: SAMEORIGIN
< X-XSS-Protection: 1; mode=block
< X-Content-Type-Options: nosniff
< Location: https://example.com/some-path
< Content-Type: text/html; charset=utf-8
< Cache-Control: no-cache
< X-Request-Id: f3211d6c-4e77-448b-a44d-7ad080fe5d3f
< X-Runtime: 0.002391
< Transfer-Encoding: chunked
<

> GET /some-path HTTP/1.1
> Host: example.com
> User-Agent: curl/7.43.0
> Accept: */*
>
< HTTP/1.1 404 Not Found
......
```

The `U0VDUkVUX1RPS0VOOg==` in the `Authorization` header above is the secret, Base64 encoded:

```
$ echo U0VDUkVUX1RPS0VOOg== | base64 --decode
SECRET_TOKEN:
```

## Don't Redirect At All

Of course, redirecting is not the only option: Your endpoint can act as a proxy and read the contents from the external server and pass along to the client. The penalty is that the client connection to your server will stay open longer, consume more computation resources and transfer more data than a redirect.


## Conclusion

Be careful when redirecting to external servers and you are using header-based authentication. Some clients may forward those headers along to a third party.

[^1]: We can ignore the 404 response. This is a made up example, and it's irrelevant how the external server actually responded.
[httpie]: https://httpie.org/
