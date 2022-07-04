---
layout: post
title: "The REPL: Issue 94 - June 2022"
date: 2022-07-04 12:40:42 -0700
categories:
- the repl
excerpt_separator: <!-- more -->
---

### [Incremental View Maintenance Implementation as a PostgreSQL extension][pg_ivm]

I've written before about [leveraging Postgres views][pgviews], focusing on non-materialized views. Materialized views bring other benefits beside abstractions: Namely they can increase the performance of data loading, by doing some of the computations ahead of time (and trading off disk space). Using materialized views has some difficulties, because Postgres requires that the data refresh be explicitly managed, and that it refreshes a whole table at once.

The `pg_ivm` extension promises to make it much easier to work with materialized views:

> **Incremental View Maintenance (IVM)** is a way to make materialized views up-to-date in which only incremental changes are computed and applied on views rather than recomputing the contents from scratch as `REFRESH MATERIALIZED VIEW` does. IVM can update materialized views more efficiently than recomputation when only small parts of the view are changed.

I have not used this in production, but it looks very promising

### [Engineering Levels at Honeycomb: Avoiding the Scope Trap][honeycomb]

The folks at Honeycomb discuss how they think about their engineering ladder. In particular, they are mindful of falling into the "scope trap". In said trap, only engineers that work on the biggest projects get promoted. I like their visualization of ownership vs scope and how different levels overlap.

### [On the Dangers of Cryptocurrencies and the Uselessness of Blockchain][schneier]

I respect Bruce Schneier's opinion on security and technology a lot:

> Earlier this month, I and others wrote a letter to Congress, basically saying that cryptocurrencies are an complete and total disaster, and urging them to regulate the space. Nothing in that letter is out of the ordinary, and is in line with what I wrote about blockchain in 2019.

There is no good case for crypto: It's a solution in search of a problem.

[pg_ivm]: https://github.com/sraoss/pg_ivm
[pgviews]: {% post_url 2021-01-04-abstractions_with_database_views %}
[honeycomb]: https://www.honeycomb.io/blog/engineering-levels-at-honeycomb/
[schneier]: https://www.schneier.com/blog/archives/2022/06/on-the-dangers-of-cryptocurrencies-and-the-uselessness-of-blockchain.html