---
layout: post
title: "The REPL: Issue 17 - December 2015"
date: 2016-01-05 08:55:31 -0800
comments: true
categories:
- the repl
excerpt_separator: <!-- more -->
---

### [How To Test Multithreaded Code][1]

Mike Perham, author of Sidekiq, the popular Ruby queueing library, writes a great post on how to test multithreaded code. The first portion, deals with separating the threading portion from other logic, so that it can be tested with regular means. In addition, he details how using a callback and the native Ruby `Mutex` and `ConditionalVariable` one can test threading code, without using any `sleep` calls. Very informative post.

### [Is Rest Best In A Microservices Architecture?][2]

Craig Williams discusses why REST over HTTP is not necessarily the best option for communicating between microservices. He illustrates two other options: Pipelines and messaging and talks about the pros and cons of each. It's a topic that I have personally though about much and at work, we have started using messaging as opposed to REST for the reasons outlined in the article.


### [Learn to Code: It’s Harder Than You Think][3]

As Mike Hadlow, the author states in the TL;DR:

> All the evidence shows that programming requires a high level of aptitude that only a small percentage of the population possess. The current fad for short learn-to-code courses is selling people a lie and will do nothing to help the skills shortage for professional programmers.

The perspective and numbers in the article are particular for the UK, but I believe they apply equally well to the US.

[1]: http://www.mikeperham.com/2015/12/14/how-to-test-multithreaded-code/
[2]: http://capgemini.github.io/architecture/is-rest-best-microservices/
[3]: http://blog.debugme.eu/learn-to-code/
