---
layout: post
title: "Renewing a Let's Encrypt Certificate"
date: 2016-12-07 13:30:12 -0800
comments: true
categories:
  - security
---

I previously wrote about changing my certificate authority to Let's Encrypt. About the only downside I found about using it with my hosting service, Nearly Free Speach, is the need to manually renew every 3 months. Today, I went through the process and found it to be relatively simple.

To renew the certificate, I ran `certbot` like this on my machine:

```
$ sudo certbot certonly --manual
```

This initiated the in-terminal process, with instructions on adding some specific content to the domain to ensure you control it. After the verification the certificates where issued and placed in `/etc/letsencrypt/live/ylan.segal-family.com/`.

The generated certificate contents looks like this:

```
$ openssl x509 -in cert.pem -text -noout
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            03:b3:26:9f:ed:b0:58:d7:57:6f:ba:0d:0c:8e:85:cb:f0:d8
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=US, O=Let's Encrypt, CN=Let's Encrypt Authority X3
        Validity
            Not Before: Dec  7 20:42:00 2016 GMT
            Not After : Mar  7 20:42:00 2017 GMT
        Subject: CN=ylan.segal-family.com
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
            RSA Public Key: (2048 bit)
                Modulus (2048 bit):
                    00:b2:3c:2d:4e:2b:cc:ae:c2:75:08:43:08:f7:2d:
                    cc:fa:05:06:36:e6:06:9f:48:1a:71:a2:aa:c0:4f:
                    01:9d:e7:b2:a0:1b:18:ec:48:ef:59:ec:98:93:89:
                    e5:7a:a7:e4:62:b1:32:85:cf:60:72:40:81:46:71:
                    b8:6f:8d:d1:bb:5d:7d:d4:cd:9c:49:ad:94:8d:ba:
                    98:ad:01:db:d1:7f:f9:98:e3:c2:50:43:97:50:f0:
                    b0:a8:58:8a:e9:5d:f3:d9:88:4a:63:77:4a:06:b2:
                    5d:16:a2:66:6d:1d:b7:2b:c2:90:8f:30:90:18:3d:
                    23:09:8d:fb:07:4c:32:c5:bf:3b:3a:3b:fd:f5:49:
                    7e:e9:2e:82:e5:31:59:3c:b7:c3:e8:07:b9:a8:b6:
                    c7:11:f0:53:36:0a:d9:58:a5:26:09:42:51:b7:9c:
                    78:8c:c0:01:e8:0d:44:7c:eb:66:c8:b4:49:09:22:
                    69:48:94:68:9c:d5:ce:c1:9d:bf:e1:b1:4c:b3:ff:
                    f2:eb:c0:66:e4:7b:1a:1c:4e:24:71:bf:f5:e9:8a:
                    bb:8d:e7:50:5c:f6:01:32:09:53:fd:fe:2f:96:eb:
                    f2:6a:44:7f:dc:5e:f6:c6:18:1a:02:99:b2:0b:45:
                    53:25:b2:97:1c:c4:67:61:99:2b:d7:2a:d6:52:e0:
                    90:2b
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment
            X509v3 Extended Key Usage:
                TLS Web Server Authentication, TLS Web Client Authentication
            X509v3 Basic Constraints: critical
                CA:FALSE
            X509v3 Subject Key Identifier:
                17:5A:1E:01:42:05:20:F2:CA:AE:CB:BA:84:49:DB:53:02:7D:76:3E
            X509v3 Authority Key Identifier:
                keyid:A8:4A:6A:63:04:7D:DD:BA:E6:D1:39:B7:A6:45:65:EF:F3:A8:EC:A1

            Authority Information Access:
                OCSP - URI:http://ocsp.int-x3.letsencrypt.org/
                CA Issuers - URI:http://cert.int-x3.letsencrypt.org/

            X509v3 Subject Alternative Name:
                DNS:ylan.segal-family.com
            X509v3 Certificate Policies:
                Policy: 2.23.140.1.2.1
                Policy: 1.3.6.1.4.1.44947.1.1.1
                  CPS: http://cps.letsencrypt.org
                  User Notice:
                    Explicit Text: This Certificate may only be relied upon by Relying Parties and only in accordance with the Certificate Policy found at https://letsencrypt.org/repository/

    Signature Algorithm: sha256WithRSAEncryption
        35:98:2b:c4:ed:e3:93:5b:2a:61:f0:cb:1d:23:3f:d8:15:79:
        eb:92:f4:79:e9:a2:31:2b:d1:35:bc:0c:5d:89:ad:ec:ed:56:
        2c:d2:77:bc:f0:19:64:7c:04:9b:76:6c:16:84:23:b5:94:9a:
        74:2e:2e:3c:18:47:ee:73:6e:d9:b5:2c:dd:89:c5:1e:ec:a4:
        c0:c4:e7:8c:35:9f:a0:af:ec:87:ea:78:81:45:6b:e5:db:b3:
        60:0a:02:08:4e:92:5a:da:5c:d8:95:d3:45:7d:d7:3f:07:2e:
        0c:a3:dc:a8:4f:1a:e8:e7:9b:d7:09:2e:d7:f3:2c:c2:c0:ba:
        78:70:11:12:62:37:80:e6:e3:cb:a0:04:e6:19:f3:0a:eb:74:
        64:50:e6:90:e5:60:32:f6:f6:d4:e8:db:94:6a:47:76:25:34:
        23:e0:13:2b:19:a0:de:33:7c:33:a2:fb:7e:03:79:d6:30:ab:
        f8:85:3d:27:3c:d4:69:9a:f9:da:b4:5c:88:b5:1c:95:5d:64:
        8f:2c:26:eb:73:f9:08:4c:ec:30:d8:91:82:a7:0a:ed:9c:82:
        b5:24:b7:54:38:04:61:47:5e:ac:02:83:81:cf:d7:29:d6:74:
        b2:90:3d:0c:75:2a:e3:12:f2:3d:53:96:9d:ca:48:c4:bc:b3:
        a8:94:5a:d2
```

As was the case when first installing the certificates, Nearly Free Speach requires them to be concatanated and pasted into their form:

```
$ cat fullchain.pem privkey.pem | pbcopy

```

The changes take place immeditely. I now have 3 more months of a valid TLS certificate for this web-site.
