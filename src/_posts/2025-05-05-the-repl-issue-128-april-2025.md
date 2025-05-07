---
layout: post
title: "The REPL: Issue 128 - April 2025"
date: 2025-05-05 16:18:38 -0700
categories:
- the repl
- software
- ruby
excerpt_separator: <!-- more -->
---

### [Conway's Law](https://buttondown.email/noelrap/archive/conways-law/)

A good explanation why Conway's law makes sense as a response to real communication problems. The solution to those problems is to minimize the communication paths to avoid being bogged down. Of course, less communication paths also means less collaboration and silos. There is no silver bullet, but knowing about the phenomena makes it easier to organize towards goals.

### [Ruby might be faster than you think]()

Like the a not-for-polite-company adage says, everyone has a benchmark. A recent project made the rounds adding support for using crystal to speed up Ruby very easily. The author of this post shows, that a bit of work on what is actually benchmarked makes it so the Ruby-only version performs faster than the Crystal version. Well, that is interesting. Which benchmark should you trust? The one that is appropriate for your use case, naturally <span class="emoji">😄</span>.

### [An unfair advantage: multi-tenant queues in Postgres](https://docs.hatchet.run/blog/multi-tenant-queues)

I didn't look very closely at the algorithm, but the idea is that if you distribute jobs at write time, you save work at read-time, making the dequeuing faster, and avoids doing coordination work when you read. I've seen this too in production systems that have very "hot" queues.
