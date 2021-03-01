---
layout: post
title: "Book Review: Designing Data-Intensive Applications"
date: 2019-07-10 15:02:22 -0700
comments: true
categories:
- books
- design
- databases
---

[Designing Data-Intensive Applications][book] is one of the best technical books I've read in a long time. Data storage and retrieval is central to most software projects. There is ever-growing ecosystem of databases, stream processing, messaging queues, and other related systems. The book successfully explains how this technologies are different, how they are similar, and how they fit together.

The book is split into three parts. In Part I, _Foundations of Data Systems_, you will become acquainted with the underlying algorithms that modern database systems use to store and retrieve data, the difference between relational, No-SQL, and graph databases. You will learn what different vendors *think* ACID means, and what guarantees are actually made by different transaction levels. Part II, _Distributed Data_, covers replication, partitioning, common pitfalls with distributed systems, and how it all ties to the central problem: consistency and consensus. In Part III, _Derived Data_, we learn about batch processing and stream processing; their similarities, differences, and failure tolerance characteristics


Along the way, Kleppmann covers even sourcing, change data capture, immutable logs (think Kafka), and how they can be leveraged to build applications. The explanations in the book are are so clear, that they make the topics appear simple and accessible. For example, I gained a lot of insight by framing data either as part of the system-of-record vs derived data. In the same vein, thinking about the data journey being divided in the write path and read path is very useful. Any work *not* done on the write path, will need to be done on the read path. By shifting that boundary, we can optimize one or the other.

I highly recommend this book to any engineer with interests in backend data systems.

[book]: http://dataintensive.net/
