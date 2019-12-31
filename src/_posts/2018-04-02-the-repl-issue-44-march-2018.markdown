---
layout: post
title: "The REPL: Issue 44 - March 2018"
date: 2018-04-02 18:38:00 -0700
comments: true
categories:
- the repl
---

## [Mistakes Rails Developers Make in Elixir Part 1: Background Jobs][mistakes]

Background jobs in Rails are a common patter. In this post Desmond Bowe explores some of the available patterns in Elixir that can be used *instead* of reaching for a background queue. The information is very good. In my experience, every time I reach for background jobs, I also need to ensure that jobs survive node crashes. For that, the author still advises to use a traditional background queue.

## [A Career Cold Start Algorithm][cold]

Andrew Bosworth (Boz) advocates a simple way to start a new job: Ask everyone what is it that they think that you need to know, what are their challenges and who should you talk to next. This is a great idea, especially in places where a robust knowledge transfer process is not in place.

## [Elapsed time with Ruby, the right way][time]

Luca Guidi explains why the naive use of `Time.now` to measure elapsed time between starting and ending an expensive operation is wrong. What to use? Monotonic time.

> Remember: wall clock is for telling time, monotonic clock is for measuring time.

[mistakes]: http://crevalle.io/mistakes-rails-developers-make-in-phoenix-pt-1-background-jobs.html
[cold]: http://boz.com/articles/career-cold-start.html
[time]: https://blog.dnsimple.com/2018/03/elapsed-time-with-ruby-the-right-way/
