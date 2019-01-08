---
layout: post
title: "The REPL: Issue 53 - December 2018"
date: 2019-01-08 13:47:56 -0800
comments: true
categories:
- the repl
---

### [Scaling engineering organizations][1]

Raylene Yung at Stripe writes a detailed post about how to scale engineering organizations. Although in my current role I am *not* a hiring manager, I find these types of posts very useful for future reference and to see what hiring looks like from the other side. Understanding the system allows you to use it for your benefit.

### [PostgresSQL: Implicit vs. explicit joins][2]

Hans-Jürgen Schönig writes an excellent technical explanation of implicit vs. explicit joins in Postgres. It mostly jives with my experience: For the most part, the query planner will ensure that the performance is the same. When writing SQL directly, I prefer to use explicit joins. I believe they are more readable.

[1]: https://stripe.com/atlas/guides/scaling-eng#introduction
[2]: https://www.cybertec-postgresql.com/en/postgressql-implicit-vs-explicit-joins/
