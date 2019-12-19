---
layout: post
title: "The REPL: Issue 59 - July 2019"
date: 2019-08-02 14:10:44 -0700
comments: true
categories:
- the repl
---

### [View-centric performance optimization for database-backed web applications][1]

This post is a walk-through of of the [academic paper][paper] with the same title. Keeping page-load time low continues to be important, but it has become an increasingly challenging task, due to the ever-growing amount of data stored in back-end systems. The authors created a view-centric development environment that provides intuitive information about the cost of each HTML element on page, along with the performance-enhancing opportunities can be highlighted. The goal is to make it easier to explore functionality and performance trade-offs.

Interestingly, the development environment, Panorama, targets the Ruby on Rails framework specifically. I look forward to trying it out soon.

## [Zanzibar: Google’s Consistent, Global Authorization System][2]

This paper includes a thorough description of the architecture behind Zanzibar, a global system for storing and evaluating access control lists internal to Google. As a highly distributed system, it builds on top of other Google technology, like Spanner -- a distributed NoSQL database. In particular, I was very interested in consistency model and how they provide guarantees around external consistency so that the casual ordering of events is maintained. It achieves this by providing clients with tokens after write operations (called a *zookie*): When a client makes a subsequent request with that token, the system guarantees that any results are **at least** as fresh as the timestamp encoded in the zookie.

The paper has a lot more, including how they architect for performance with caching layers, and a purpose-built indexing system for deeply nested recursive permission structures.

[1]: https://blog.acolyer.org/2019/07/12/view-centric-performance-optimization/
[paper]: https://people.cs.uchicago.edu/~shanlu/paper/panorama.pdf
[2]: https://ai.google/research/pubs/pub48190
