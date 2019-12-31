---
layout: post
title: "The REPL: Issue 54 - February 2019"
date: 2019-03-01 11:41:19 -0800
comments: true
categories:
- the repl
---

### [Move fast and migrate things: how we automated migrations in Postgres][1]

Vineet Gopal from Benchling writes an interesting post about their approach to running migrations on highly-contested databases in production. A new concept for me was that they **automatically** retry migrations that fail due to lock timeouts. This reduces the number of failed deployments and manual intervention steps.

### [Rescue from errors with a grace][2]

In this post Paweł Dąbrowski shows how to leverage Ruby's value equality (`===`) method, and overriding the default functionality in custom exceptions. The results is cleaner exception handling code.

### [Distributed Phoenix Chat with PubSub PG2 adapter][3]

Alvise Susmel writes in detail how to use Phoenix Chat PubSub implementation using the `pg2` library. The result a distributed, multi-node chat service that does **not** have an external dependency to a separate system (like Redis).

[1]: https://benchling.engineering/move-fast-and-migrate-things-how-we-automated-migrations-in-postgres-d60aba0fc3d4
[2]: http://pdabrowski.com/blog/ruby/rescue-from-errors-with-a-grace/
[3]: https://www.poeticoding.com/distributed-phoenix-chat-with-pubsub-pg2-adapter/
