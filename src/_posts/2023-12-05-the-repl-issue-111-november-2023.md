---
layout: post
title: "The REPL: Issue 111 - November 2023"
date: 2023-12-05 15:40:14 -0800
categories:
- postgres
- software
excerpt_separator: <!-- more -->
---


# [River: a Fast, Robust Job Queue for Go + Postgres](https://brandur.org/river)

I don't write go-lang, and don't have any insights into this new queue. The introduction of **why** a database based queue solves the dual-write problem are clear and applicable to any other system. Transactionality is one of the main reasons that I recommend [GoodJob](https://github.com/bensheldon/good_job). The other one, also discussed is that operationally, having less data-stores is a win.

A number of Postgres improvements also make it more performant than previous attempts at using db-backed job queues.

Coincidentally, I was listening to a [recent podcasts](https://yagni.fm/episodes/redis-w-nate-berkopec). They were discussing Redis as a store for background queuing. I was disappointed that they didn't mention the dual-write problem as a pro of relational database queues.

# [Rob Pike's 5 Rules of Programming](https://users.ece.utexas.edu/~adnan/pike.html)

Concise and interesting. I've internalized as a best practice avoiding premature optimization. Rule 5 has me thinking a bit. Most web application programming doesn't need to think much about data structures in memory, rather about how to design the database schema for storage.
