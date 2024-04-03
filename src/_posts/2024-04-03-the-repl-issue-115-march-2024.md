---
layout: post
title: "The REPL: Issue 115 - March 2024"
date: 2024-04-03 09:44:40 -0700
categories:
- unix
- postgres
excerpt_separator: <!-- more -->
---

### [Bash Debugging](https://wizardzines.com/comics/bash-debugging/)

Another gem by Julia Evans. I always learn something from her zines, and this is no exception: You can have a step debugger in bash!

### [How Figma's Databases Team Lived to Tell the Scale](https://www.figma.com/blog/how-figmas-databases-team-lived-to-tell-the-scale/)

Very interesting article on how Figma managed to scale Postgres. Having a DB proxy that checks the queries and routes to the correct shard (and even aggregates among shards) is wild.

The use of logical partitioning to prove their work before doing actual physical partitioning is very clever.

Before going out and building a custom replication scheme, remember that there are out-of-the-box solutions out there that most organizations are better choosing over custom solutions.

### [jnv: interactive JSON filter using jq](https://github.com/ynqa/jnv)

`jnv` looks like a nice tool for interactively exploring the a JSON file.
