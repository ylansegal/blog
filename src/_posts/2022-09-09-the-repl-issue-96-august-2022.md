---
layout: post
title: "The REPL: Issue 96 - August 2022"
date: 2022-09-09 09:49:47 -0700
categories:
- the repl
- unix
excerpt_separator: <!-- more -->
---

### [Your Makefiles are wrong][1]

`make` is a very powerful build tool, but it has sharp edges. In this post Jacob Davis-Hansson explains some best practices to improve the experience. The key insight is that each make target, by default, is suppose to generate a file, and execution is determined by laying out dependencies between files.

### [Why are you so busy?][2]

> as long as you are doing your work well and continuously working on the next most important thing prioritised by the business, any pressure to deliver beyond what your team is capable of is objectively unreasonable.

Tom Lingham writes about being busy in software engineering teams. The quote above gets at the crux of the problem: You can only do so much. Asking for more, means that you need to work more or take shortcuts. Both of those lead to non-sustainable work. The appropriate response is to push back and have the tough conversations.

[1]: https://tech.davis-hansson.com/p/make/
[2]: https://tomlingham.com/articles/why-are-you-so-busy/
