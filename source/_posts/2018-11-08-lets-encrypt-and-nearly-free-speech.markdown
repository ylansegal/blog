---
layout: post
title: "Let's Encrypt and NearlyFreeSpeech.NET"
date: 2018-11-08 12:30:54 -0800
comments: true
categories:
- security
---

At the time of this writing, this blog is hosed on [NearlyFreeSpeech.NET][nfs], and delivered securely over TLS with a certificate from [Let's Encrypt][lets]. I previously wrote about how I [obtained the first certificate][setup] and how to [renew it][renew]. The process is now even easier, because NearlyFreeSpeech.NET automates the [setup and renewal][faq] for it's members.

The process could not be simpler:

1. `ssh` into your account
2. Run `tls-setup.sh`
3. Profit!

```
$ ssh YOUR_USERNAME@ssh.phx.nearlyfreespeech.net
# ...
[\h \w]\$ tls-setup.sh
Creating base directory for Dehydrated.

To use Let's Encrypt you must agree to their Subscriber Agreement,
which is linked from:

    https://letsencrypt.org/repository/

Do you accept the Let's Encrypt Subscriber Agreement (y/n)? y
# INFO: Using main config file /usr/local/etc/dehydrated/config
+ Generating account key...
+ Registering account key with ACME server...
+ Done!
# INFO: Using main config file /usr/local/etc/dehydrated/config
 + Creating chain cache directory /home/private/.dehydrated/chains
Processing ylan.segal-family.com
 + Creating new directory /home/private/.dehydrated/certs/ylan.segal-family.com ...
 + Signing domains...
 + Generating private key...
 + Generating signing request...
 + Requesting new certificate order from CA...
 + Received 1 authorizations URLs from the CA
 + Handling authorization for ylan.segal-family.com
 + 1 pending challenge(s)
 + Deploying challenge tokens...
 + Responding to challenge for ylan.segal-family.com authorization...
 + Challenge is valid!
 + Cleaning challenge tokens...
 + Requesting certificate...
 + Checking certificate...
 + Done!
 + Creating fullchain.pem...
 + Installing new certificate for ylan.segal-family.com...
INFO: Enabling TLS for ylan.segal-family.com
e5: OK (ylan.segal-family.com)
e6: OK (ylan.segal-family.com)
e1: OK (ylan.segal-family.com)
e4: OK (ylan.segal-family.com)
e2: OK (ylan.segal-family.com)
e3: OK (ylan.segal-family.com)
OK: Setup was fully confirmed.
 + Done!
Adding scheduled task to renew certificates.
success=true
```

That is it! No more manual certificate renewal. Thank you NearlyFreeSpech.NET!

This is a great example of how far we've come. It used to be very expensive to have a TLS certificate for a small website, because of the cost of the certificate *and* the usual extra hosting cost to use TLS. The renewal process was complicated as well. Let's Encrypt has changed that: It is now **free** to obtain a certificate. They are shorter-lived than traditional certificates, which in turn makes them more secure by requiring renewing often. They have also invested in an API and tooling to make it easy to setup and automate renewal, so that more of the internet is now encrypted. Thank you Let's Encrypt!

[nfs]: https://members.nearlyfreespeech.net/ylansegal/
[lets]: https://letsencrypt.org/
[setup]: /blog/2016/09/29/goodbye-startssl-hello-lets-encrypt/
[renew]: /blog/2016/12/07/renewing-a-lets-encrypt-certificate/
[faq]: https://faq.nearlyfreespeech.net/section/ourservice/sslcertificates#sslcertificates
