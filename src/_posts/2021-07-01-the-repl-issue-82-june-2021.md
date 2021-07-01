---
layout: post
title: "The REPL: Issue 82 - June 2021"
date: 2021-07-01 15:36:20 -0700
categories:
- the repl
excerpt_separator: <!-- more -->
---

### [EXPLAIN ANALYZE in PostgreSQL and how to interpret it][1]

I've been working on web applications for a long time. From time to time I am called upon to figure out (and optimize) performance issues on some query. `EXPLAIN ANALYZE` lets you see what Postgres is doing under the hood. I don't do this often enough to remember all the detail of what all the information returned means. This article explains the basics of `EXPLAIN ANALYZE` and links to some handy tools that help you focus on what matters.

### [Do You Need Redis? PostgreSQL Does Queuing, Locking, & Pub/Sub][2]

It's no secret that I like Postgres a lot. This article explains some common use cases for Redis, and how Postgres can take care of them instead. It resonates with me, especially for smaller projects were the techniques outlined can avoid using _another_ data store.

### [Stop worrying about PostgreSQL locks in your Rails migrations][3]

To round off today's Postgres love, this blog post introduces how the `safe-pg-migrations` [gem][4] can help when running migrations for databases with high-load and/or a lot of data. Traditionally, those operations can be problematic because of how Postgres acquires locks and can bring production sites down. The specifics are explained in detail in the post. The `safe-pg-migrations` gem manages to turn what would be complicated steps to ensure safe migrations into the same exact semantics that `ActiveRecord::Migration` uses.

As soon as I tried this gem, I ran into [an issue][5]. The maintainer was very helpful. It turns out Ruby 3.0 support was pending. A few days later my issue was resolved.

[1]: https://www.cybertec-postgresql.com/en/how-to-interpret-postgresql-explain-analyze-output/
[2]: https://spin.atomicobject.com/2021/02/04/redis-postgresql/
[3]: https://medium.com/doctolib/stop-worrying-about-postgresql-locks-in-your-rails-migrations-3426027e9cc9
[4]: https://github.com/doctolib/safe-pg-migrations
[5]: https://github.com/doctolib/safe-pg-migrations/issues/44
