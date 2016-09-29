---
layout: post
title: "Goodbye StartSSL, Hello Let's Encrypt"
date: 2016-09-29 15:53:12 -0700
comments: true
categories:
- security
---

Mozilla is considering taking action against two Certificate Authorities, WoSign and StartCom after an [investigation][investigation] into improper behavior, including not reporting that the WoSign bought StartCom outright.

As I [wrote about earlier][tls_post], this blog used a StartCom TLS certificate, under their StartSSL brand, which was free. At the time, the only reason why I didn't pick Let's Encrypt was because the certificate expiration is every 3 months. However, given the contents of the report, I would much rather use an organization that wants to make the web better -- not exploit it.

Obtaining and installing the new certificate, turned out to to be an easy process.

## Obtaining A Certificate From Let's Encrypt

I used the `certbot` client to obtain a certificate. On my mac, I installed via Homebrew:

```
$ brew install certbot

```

`certbot` can request and install the certificate, if it's executed in the same machine that runs the web-server. In my case, I just wanted the certificates to be generated and downloaded locally.

```
$ sudo certbot certonly --manual
```

During the in-terminal process, `certbot` will ask for the intended domain and instruct you to make available some specified content at a particular url in that domain. This is to prove that you the person requesting the TLS certificate is an administrator for that domain. For me, this involved copying one new file to my hosting service.

After that, the certificate is issued immediately and available locally at `/etc/letsencrypt/live/ylan.segal-family.com` (your domain will vary).

## Installing The New Certificate

The last time I installed a certificate, I had to open a support ticket at [Nearly Free Speech][nfs]. Since then, they have made the process automated and available from the control panel. The instructions are to paste into the provided form the certificate (including the full cert chain) and private key, all into the same field:

```
$ cat fullchain.pem privkey.pem | pbcopy

```

A few seconds later, the new certificate was installed and being served on this domain.

## Conclusion

The Let's Encrypt process ended up being simpler than StartSSL, since there was no need to manually create the private key and certificate signing request: It's all done with one command.


[investigation]: http://news.softpedia.com/news/mozilla-ready-to-ban-wosign-certificates-for-one-year-after-shady-behavior-508674.shtml
[tls_post]:/blog/2016/02/19/this-blog-is-now-delivered-over-tls/
[nfs]: https://www.nearlyfreespeech.net/
