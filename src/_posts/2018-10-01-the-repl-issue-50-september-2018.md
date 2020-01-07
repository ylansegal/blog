---
layout: post
title: "The REPL: Issue 50 - September 2018"
date: 2018-10-01 16:38:25 -0700
comments: true
categories:
- the rep
excerpt_separator: <!-- more -->
---

### [How to teach yourself hard things][1]

Julia Evans writes a great article on how to learn... to learn. In her traditional straight-forward fashion, she describes the method she has used to learn things that are difficult. She breaks the process down into approachable skills that anyone can learn (e.g ask questions, have confidence in your knowledge). I also recommend following her on [twitter][twitter]. She posts comics often about unix tools: I *always* learn something knew from them.

### [Distributed Agreement on Random Order – Fun with Lamport Timestamps][2]

If you've ever done some digging into distributed computing, you will have heard of Lamport Clocks. In this post, Quentin Duval, details step by step on how to construct an application that uses Lamport's algorithm for reaching agreement on the order of events across a distributed system.

### [Upgrading GitHub from Rails 3.2 to 5.2][3]

Working as a Rails developer, I've found myself a few times in the same situation GitHub was: Relying on an old version of a framework that has now become a liability, and upgrading is anything but straight forward. In this post, Eileen Uchitelle describes the strategy that GitHub used to upgrade. I especially like the section about lessons learned: It's one of my favorite things about the software community. The willingness to share with others allows us to learn from each other. Thanks Eileen!

[1]: https://jvns.ca/blog/2018/09/01/learning-skills-you-can-practice/
[2]: https://deque.blog/2018/09/13/distributed-agreement-on-random-order-fun-with-lamport-timestamps/
[3]: https://githubengineering.com/upgrading-github-from-rails-3-2-to-5-2/
[twitter]: https://twitter.com/b0rk
