---
layout: post
title: "The REPL: Issue 14 - September 2015"
date: 2015-10-02 08:45:20 -0700
comments: true
categories:
- the rep
excerpt_separator: <!-- more -->
---

### [How We Ended Up With Microservices][1]

Phil Calçado writes a detailed post on the non-technical side of _why_ Soundcloud  moved away from a monolithic Rails app, in favor of a microservices architecture. Main reason: productivity. They were able to reduce their time-to-launch of new features from 66 days to 16 days.

### [A Gentle Introduction To Actor-based Concurrency][2]

Originally published 2 years ago, Practicing Ruby provides a great explanation of what the Actor model looks like in Ruby. He solves the [Dinning Philosophers Problem][4] with bare ruby, the with Celluloid and then shows a simple implementation of actors in ruby would look like. Great read.  

### [Implementing Worker Threads in Rails][3]

Did you know that when a process is forked in ruby, only the main thread is copied and all other threads are dead? Neither did I, until I ran into it recently. Solving threading issues is very hard. This post has great techniques on how to use threads in Rails, even if using forking servers.

[1]: http://philcalcado.com/2015/09/08/how_we_ended_up_with_microservices.html
[2]: https://practicingruby.com/articles/gentle-intro-to-actor-based-concurrency
[3]: http://blog.arkency.com/2013/06/implementing-worker-threads-in-rails/
[4]: https://en.wikipedia.org/wiki/Dining_philosophers_problem
