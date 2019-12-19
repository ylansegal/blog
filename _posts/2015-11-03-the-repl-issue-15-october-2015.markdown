---
layout: post
title: "The REPL: Issue 15 - October 2015"
date: 2015-11-03 08:43:49 -0800
comments: true
categories:
- the repl
---

### [Speed up with Materialized Views on PostgreSQL and Rails][1]

Materialized views are a way to cache the result of expensive database computations, right on the database. Used in the right manner, they can make speed up performance significantly. As with any other caching mechanism, there exists some caveats about invalidating the cache when underlying data changes. This guide shows how to leverage this database feature in a Rails app. Clear and to the point.

### [Debugging a Memory Leak on Heroku][2]

Richard Schneeman writes another insightful post on how to make Ruby applications better. In this case, he talks about how to identify memory leaks (as opposed to memory bloat) and different techniques to mitigate memory leaks. Plenty of good techniques discussed.

### [What Would Feynman Do?][3]

One of my favorite books, is [Surely You're Joking, Mr. Feynman!][5], by Nobel-prize winning physicist Richard Feynman, a collection of anecdotes from his life, in which is unique way of viewing the world and  whimsical approach to problem solving is highlighted. This blog post imagines Mr. Feynman at a job interview, where he is asked to solve a "later-thinking" puzzle. It's hilarious. If you enjoyed it, don't hesitate to read the book.

### [Communication: how to be a better software developer][4]

Targeted to software developers trying to level up, this articles has great tips on how to be a better communicator and why it's important. The advice resonates with me. Really, every one can benefit from being better at *people*, no?

[1]: http://www.sitepoint.com/speed-up-with-materialized-views-on-postgresql-and-rails/?utm_source=rubyweekly&utm_medium=email
[2]: https://blog.codeship.com/debugging-a-memory-leak-on-heroku/
[3]: http://blogs.msdn.com/b/ericlippert/archive/2011/02/14/what-would-feynman-do.aspx
[4]: https://medium.com/@joonty/communication-how-to-be-a-better-software-developer-869c50767701#.m68p77bkk
[5]: https://en.wikipedia.org/wiki/Surely_You%27re_Joking,_Mr._Feynman!
