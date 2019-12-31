---
layout: post
title: "The REPL: Issue 61 - September 2019"
date: 2019-10-01 13:04:50 -0700
comments: true
categories:
- the repl
---
### [Building A Relational Database Using Kafka][1]

Robert Yokota explores building a relational database on top of Kafka. It follows his previous article on [creating an in-memory cache][3] on backed by Kafka. RDBM systems are commonly thought of keeping track of tables and rows. The semantics of SQL reinforce the concept of rows being updatable. In practice though, most implementation use an immutable log under the hood. That is what [makes transactions possible][4], each with its own consistent view of the world. Kafka can be thought of as an "exposed" MVCC system, and the current state of the data can be derived by consuming the messages in a topic. The article is interesting in that it assembles a relation database by using different existing open-source projects.

### [3 Key Ideas Behind The Erlang Thesis][2]

Yiming Chen summarizes Joe Armstrong's thesis: ["Making reliable distributed systems in the presence of software errors"][5]. The 3 key ideas identified: Concurrency oriented programming, abstracting concurrency, and let-it-fail philosophy. Armstrong is Erlang's creator, and his thesis has been very influential in the Erlang and Elixir communities.

[1]: https://yokota.blog/2019/09/23/building-a-relational-database-using-kafka/
[2]: https://yiming.dev/clipping/2019/09/04/3-key-ideas-behind-the-erlang-thesis/
[3]: https://yokota.blog/2018/11/19/kcache-an-in-memory-cache-backed-by-kafka/
[4]: https://en.wikipedia.org/wiki/Multiversion_concurrency_control
[5]: http://erlang.org/download/armstrong_thesis_2003.pdf
