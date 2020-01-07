---
layout: post
title: "The REPL: Issue 52 - November 2018"
date: 2018-12-05 17:25:22 -0800
comments: true
categories:
- the rep
excerpt_separator: <!-- more -->
---

### [Datomic: Event Sourcing without the hassle][1]

I've never used datomic, but I've seen many references to it, especially when reading about event sourcing. In this article, Val Waeselynck explains at length why [Datomic][datomic] is better suited to fix the pain of doing event sourcing with traditional databases. I found it very interesting, even if I am *not* doing any event sourcing or considering Datomic.

### [Post-REST][2]

In this post, Tim Bray expands on what he thinks that industry is moving to, to address REST shortcopmings (e.g. latency, coupling, short life).

- *Winners*: Messaging and Eventing, Orchestration, and Perssisten Connections.
- *Losers*: GraphQL, and RPC.

### [Building SQL expressions with Sequel][3]

Janko Marohnic compares the ruby libraries `ActiveRecord` to `Sequel`. They are not strictly equivalent, but I believe the comparison is fair because they both provide a way to interact with a database. I found `Sequel`s syntax very appealing. Duly noted for future use.

[1]: https://vvvvalvalval.github.io/posts/2018-11-12-datomic-event-sourcing-without-the-hassle.html
[2]: https://www.tbray.org/ongoing/When/201x/2018/11/18/Post-REST
[3]: https://bits.citrusbyte.com/building-sql-expressions-with-sequel/
[datomic]: https://www.datomic.com/
