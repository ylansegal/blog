---
layout: post
title: "The REPL: Issue 53 - January 2019"
date: 2019-02-04 13:47:05 -0800
comments: true
categories:
- the repl
excerpt_separator: <!-- more -->
---

### [Detecting Agile BS][1]

I don't know what I like more about this guide: The fact that it calls BS a lot of what is gospel for many in the software industry, the fact that it's published by the Department of Defense, or the power-point-y graphics.

### [Distributed Transactions: The Icebergs of Microservices][2]

In this article, Graham Lea explains many potential pitfalls with distributed transactions, and general advice on how to avoid them in the first place, or deal with them effectively when must.

> The solution to distributed transactions in microservices is simply to avoid them like the plague.

### [Our Software Dependency Problem][3]

Russ Cox writes about software dependencies, and goes into great detail of what dependencies are and what risks they bring into software projects. I found myself nodding in agreement throughout the post. The need to have a good policy towards updating project dependencies has been a [pet-peeve of mine][4] for a while.


[1]: https://media.defense.gov/2018/Oct/09/2002049591/-1/-1/0/DIB_DETECTING_AGILE_BS_2018.10.05.PDF
[2]: http://www.grahamlea.com/2016/08/distributed-transactions-microservices-icebergs/
[3]: https://research.swtch.com/deps
[4]: /blog/2015/01/05/stagnation/
