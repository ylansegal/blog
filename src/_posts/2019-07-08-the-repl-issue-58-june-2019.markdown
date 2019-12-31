---
layout: post
title: "The REPL: Issue 58 - June 2019"
date: 2019-07-08 11:25:08 -0700
comments: true
categories:
- the repl
---

### [Per-project Postgres][1]

In this post, Jamey Sharp elaborates on a neat technique to run different versions of postgres on a per-project basis. I learned that you can run postgres on a Unix socket *only*, without having a port open, which removes the need to manage those ports for each version of postgres. The technique also has the advantage of keeping the data for the project, inside the project directory structure. It illustrates the power and flexibility of Unix tools.

### [How to do distributed locking][2]

Martin Kleppmann writes about distributed locks in general, and in particular the merits of [Redlock][redlock], a Redis-based distributed-lock algorithm. Kleppmann breaks down the reasons to use a distributed lock, it's characteristics, and how Redlock in particular is vulnerable to timing attacks. I found this to be great technical writing. The post came about when Kleppmann was researching his book, [Desiging Data-Intensive Applications][data]. I finished that book a few days ago, and hope to write a review soon. I can recommend it enough.

[1]: https://jamey.thesharps.us/2019/05/29/per-project-postgres/
[2]: https://martin.kleppmann.com/2016/02/08/how-to-do-distributed-locking.html
[redlock]: https://redis.io/topics/distlock
[data]: http://dataintensive.net/
