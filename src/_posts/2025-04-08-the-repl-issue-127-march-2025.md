---
layout: post
title: "The REPL: Issue 127 - March 2025"
date: 2025-04-08 18:37:53 -0700
categories:
- unix
- bash
- rails
excerpt_separator: <!-- more -->
---

### [Bash Debugging](https://wizardzines.com/comics/bash-debugging/)

Julia Evans, in here signature comic/zine style, explains how to debug bash. I was today years old when I learned that you can have a step debugger for a bash script.

### [How we migrated from Sidekiq to Solid Queue](https://www.bigbinary.com/blog/migrating-to-solid-queue-from-sidekiq)

Chirag Shah at BigBinary explain in detail how they migrated an app from Sidekiq to SolidQueue. From the configuration it seems that the queue usage is on the low side (4 types of workers, each with a single process and 3 threads).

The article doesn't mention in the article what they hoped to achieve or what their results where. I assume positive, because they close by saying they plan on doing the migration on more apps.

If I had to guess, I would say that they gained a simpler infrastructure (because they don't use redis for jobs), but more importantly, they gained transactionality: All-or-nothing writes for the models and the jobs, which is impossible using 2 separate data stores.

### [How Figma's Databases Team Lived to Tell the Scale](https://www.figma.com/blog/how-figmas-databases-team-lived-to-tell-the-scale/)

The folks at Figma tell their battle story about scaling Postgres. Having a DB proxy that checks the queries and routes to the correct shard (and even aggregates among shards) is wild.

The use of logical partitioning to prove their point before doing actual physical partitioning seems very clever.
