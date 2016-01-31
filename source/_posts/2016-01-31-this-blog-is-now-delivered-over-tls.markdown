---
layout: post
title: "This Blog Is Now Delivered Over TLS"
date: 2016-01-31 10:44:10 -0800
comments: true
categories:
- security
published: false
---

For many months, I've been wanting to add TLS support for this blog, mainly because I believe that the web needs better security. As a content publisher and website owner it is in my best interest to make my content available over a secure connection.

I recently read a [post from the Electronic Frontier Foundation][1], on how site-wide encryption helps fight censorship in other countries. The article is about Medium, a popular blogging platform and how the use of TLS prevented the Malaysian government from completely blocking the site, in an attempt to suppress speech.

I decided that it was worth my time to finally use TLS.

# Some Theory

The transfer protocol of the web is HTTP. It is a specification that allows clients (like browsers) to connect to servers and interact with them. The format is in plain text and is sent over the network in the clear. That is, without any sort of security around it. It can be trivially intercepted by anyone in the same network, as illustrated a few years ago by the [Firesheep Firefox Extension][2]

The simplest web request looks like this:

```
GET / HTTP/1.1
Host: localhost:4567
User-Agent: curl/7.43.0
Accept: */*
```

And the server might respond with:

```
HTTP/1.1 200 OK
Content-Type: text/html;charset=utf-8
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
Content-Length: 12

Hello World!
```

In order to encrypt the communication between client and server so that its private, there are a slew of standards that have emerged and technologies that come together. First a browser connects to a server and requests the server's digital certificate to verify it's authenticity. Once the browser is satisfied, there is a "handshake" in which the server and browser agree upon an encryption key to use for the session.

How does the browser know that the certificate being presented by the server is authentic? After all, the network traffic _could_ have been highjacked along the way. The browser vendors ship their software with a list of trusted Certificate Authorities (CA). When a browser connects to a server (over https) it does some math that checks that the certificate presented by the server has been *signed* by one of the CAs it trusts.

In short, a connection can be established securely between browser and server when the server presents to the browser a valid digital certificate, signed by a certificate authority trusted by the browser vendor and the server subsequently proves that it possesses the private key used to generate the certificate in the first place.

See [Wikipedia article on TLS][3] for much more information.

# Picking a CA

There are many Certificate Authorities out there that can sign a certificate. There are also many types of certificates, with things like Extended Verification (EV), wildcard domains, etc. For my purposes, the simplest one was enough. I considered two options: [Let's Encrypt][4] and [StartSSL][5].

Let's Encrypt is a new Certificate Authority that is run for the public benefit. It's mission is to create a free service so that anyone with a domain can use a the secure web.
StartSSL is a commercial CA, but offers a free tier for non-commercial use.

I am particularly excited about Let's Encrypt, however I decided to not use them. The have decided to issue certificates every 90 days. In order to not make it very onerous on the website owner, they renewal can be automated, but only for those having access for installing software in their servers.

I however, use [Nearly Free Speech[6]], which gives me affordable, metered hosting for static websites that have bare minimum requirements. They do offer TLS, but it's a manual process to setup, which I am OK with repeating yearly, but seemed a bit much every 90 days.

There is another intriguing option: CloudFlare offers free SSL termination with their free CDN service. To function, CDN require to have full control of a domain's DNS records, so that they can switch them as load shifts. CDN cache invalidation was something that I didn't want to tackle at this time, but for bigger websites it might be a great solution.

# The Nitty Gritty

Nearly Free Speech has a great concise article on their member help site on how to generate a CSR.

We first generate a private key:

```
$ openssl genrsa -out www.example.com.key 2048
```

And then a CSR:

```
$ openssl req -new -sha256 -key www.example.com.key -out www.example.com.csr
```

Using that CSR, I signed up for [StartSSL][1] free certificate. The process was simple: It required verification of domain access (they sent a verification email to the technical contact in the domain registrar's listing) and submitting the CSR.

The certificate was issued immediately, and I was able to download.

After that, I followed the instructions from Nearly Free Speech, which required me to submit a support ticket and upload the certificate and key to a protected section of my hosting space. A few minutes later, TLS was enabled!

# Cleaning Up

Service a site in TLS has a few requirement: Not only the document has to be served in TLS, but also all the assets and external resources. Otherwise, the browser cannot guarantee the security and will issue a warning, usually by having a broken padlock next to the URL.

This blog required a few tweaks, like for example loading fonts from Google via https, which where explicitly being loaded over http. For example:

``` diff
-<link href="http://fonts.googleapis.com/css?family=PT+Serif:regular,italic,bold,bolditalic" rel="stylesheet" type="text/css">
-<link href="http://fonts.googleapis.com/css?family=PT+Sans:regular,italic,bold,bolditalic" rel="stylesheet" type="text/css">
+<link href="//fonts.googleapis.com/css?family=PT+Serif:regular,italic,bold,bolditalic" rel="stylesheet" type="text/css">
+<link href="//fonts.googleapis.com/css?family=PT+Sans:regular,italic,bold,bolditalic" rel="stylesheet" type="text/css">
```

Note that instead of hardcoding `https` instead of `http`, HTML accepts references that start with `//` but no protocol: That directive is to use the same protocol that the document was loaded with.

I also changed the canonical link to my blog to be in `https`:

``` html
<link rel="canonical" href="https://ylan.segal-family.com/">
```

The `rel="canonical"` tag tells web crawlers what they should consider to be the main URL.

Once I verified that TLS was being server correctly and without warning. It was time to redirect all `http` traffic to `https`. My host uses Apache, so the process is as easy as adding a directive file:

```
# .htaccess
RewriteEngine on
RewriteCond %{HTTP:X-Forwarded-Proto} !https
RewriteRule ^.*$ https://%{SERVER_NAME}%{REQUEST_URI} [L,R=301]
```

# Conclusion

Adding TLS support was not particularly time consuming, but doing the research was. I am hopeful that new services like Let's Encrypt are going to make TLS more accessible in the near future and that the web will be a better place because of it.

[1]: https://www.eff.org/deeplinks/2016/01/mediums-sitewide-encryption-confronts-censorship-malaysia
[2]: https://en.wikipedia.org/wiki/Firesheep
[3]: https://en.wikipedia.org/wiki/Transport_Layer_Security
[4]: https://letsencrypt.org/
[5]: https://www.startssl.com/
[6]: https://www.nearlyfreespeech.net/
[7]: https://www.cloudflare.com/
