---
layout: post
title: "The REPL: Issue 41 - December 2017"
date: 2018-01-02 15:46:08 -0800
comments: true
categories:
- the rep
excerpt_separator: <!-- more -->
---

### [Trying to Represent a Tree Structure Using Postgres][trees]

Pat Shaughnessy writes a great 5 part series on using tree structures inside Postgres to store hierarchical data. In this first post he covers on why using a tree structure makes sense. In later parts he will cover the basics of the LTREE extension, how to install and use it and how it hooks into the Postgres internals.

### [Building a Distributed Log from Scratch][log]

Brave New Geek writes the first part of a promised series on building a distributed log from scratch. in this post he focuses on storage mechanics. If you interested in _why_ using a log is a good abstraction for distributed systems, see the referenced article [The Log: What every software engineer should know about real-time data's unifying abstraction][log_linked_in].

### [Distributed systems for fun and profit][fun]

Mikito Takada writes a short e-book about distributed systems at a high level, covering scalability, availability, performance, latency and fault tolerance. The implications of different levels of abstractions, time and ordering and different modes of replication are part of the fun. Warning: After reading you might find yourself going down the rabbit hole resaearching Vector Clocks and CRDTs (convergent replicated data types). See you there.

[trees]: http://patshaughnessy.net/2017/12/11/trying-to-represent-a-tree-structure-using-postgres
[log]: https://bravenewgeek.com/building-a-distributed-log-from-scratch-part-1-storage-mechanics/
[fun]:http://book.mixu.net/distsys/
[log_linked_in]: https://engineering.linkedin.com/distributed-systems/log-what-every-software-engineer-should-know-about-real-time-datas-unifying
