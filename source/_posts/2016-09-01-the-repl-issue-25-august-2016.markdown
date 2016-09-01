---
layout: post
title: "The REPL: Issue 25 - August 2016"
date: 2016-09-01 09:06:36 -0700
comments: true
categories:
- the_repl
---

### [Types][types]

Gary Bernhardt writes a great article on types, type systems and the differences in typing in different programming languages. He clarifies some of the adjective commonly associates with types: static, dynamic, weak, strong. It's a very interesting read, as are some of the comments in the gist. Gary has also re-started his [Destroy All Software][das] screencast series: I haven't watched any of the new ones, but I learned a lot from the old ones.

### [CloudFlare, SSL and unhealthy security absolutism][cloudflare]

Troy Hunt explores the services that CloudFlare provides as a content delivery network (CDN), in particular with respect to SSL (or, more properly, TLS). As with most interesting things in life, it's not black and white: CloudFlare is not evil -- like some recent blog post claim -- and provides valuable services, but users need to be aware what the security guarantees are, or more importantly what they are not. Security is hard and nuanced. The more you know...

### [The Log: What every software engineer should know about real-time data's unifying abstraction][the_log]

In the last few weeks I have been reading a lot on data pipelines. Many companies have been moving from centralized databases for all their data to distributed systems that present a set of challenges. In particular: How to make the data produced in one system available to other systems in a robust and consistent manner. In this articles Jay Kreps explains *the Log* in detail -- the underlying abstraction necessary to understand database systems, replication, transactions, etc. The Log, in this context, refers to a storage abstraction that is append-only, totally-ordered sequence of records, ordered by time. The article is long, but thorough and absolutely worth your time. Many of the concepts are similar to what is described on a post about [Apache Samza][samza], also a enlightening read.

[types]: https://gist.github.com/garybernhardt/122909856b570c5c457a6cd674795a9c
[cloudflare]: https://www.troyhunt.com/cloudflare-ssl-and-unhealthy-security-absolutism/
[the_log]: https://engineering.linkedin.com/distributed-systems/log-what-every-software-engineer-should-know-about-real-time-datas-unifying
[das]: https://www.destroyallsoftware.com/
[samza]: http://www.confluent.io/blog/turning-the-database-inside-out-with-apache-samza/
