---
layout: post
title: "The REPL: Issue 26 - September 2016"
date: 2016-10-03 08:55:59 -0700
comments: true
categories:
- the rep
excerpt_separator: <!-- more -->
---
### [Microservices – Please, don’t][please_dont]

Sean Kelly writes a cautionary post about microservices, organized into debunking 5 fallacies that he has encountered about microservices: They keep the code cleaner, they are easy, they are faster, they are  simple for engineers and, they scale better.

### [The science of encryption: prime numbers and mod n arithmetic][encryption]

While looking into [Apache Milagro][milagro], I found a link to this short paper on the math behind public-key cryptography. It's a great introduction, or refresher, to the mathematics that makes the secure web work. The paper itself has no author information, but the URL suggests that it written by Kathryn Mann at the University of California at Berkley.

### [Concurrency in Ruby 3 with Guilds][guild]

Olivier Lacan has a great explanation of Koichi Sasada recent proposal for bringing better parallelism to Ruby 3. The proposal is to introduce a new abstraction, called *Guilds* that is implemented in terms of existing Threads and Fibers, but can actually execute in parallel, because they have stronger guarantees around accessing shared state. In particular, guilds won't be able to access objects in other guilds, without explicitly transferring them via channels. It's exciting to think about Ruby's performance not being bound by the Global Interpreter Lock (GIL).

[please_dont]: http://basho.com/posts/technical/microservices-please-dont/
[encryption]: https://math.berkeley.edu/~kpmann/encryption.pdf
[guild]: https://olivierlacan.com/posts/concurrency-in-ruby-3-with-guilds/
[milagro]: http://docs.milagro.io/en/
