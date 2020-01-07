---
layout: post
title: "The REPL: Issue 63 - November 2019"
date: 2019-12-04 10:48:13 -0800
comments: true
description: Using make, how containers work
categories:
- the repl
excerpt_separator: <!-- more -->
---

### [The Language Agnostic, All-Purpose, Incredible, Makefile][make]

This post is a great introduction to `make`, one of the most versatile unix programmer tools, that has lost favor in recent years. I personally use `make` in some of my personal projects, but have yet to take advantage of it in large Ruby projects at work.

### [How containers work: overlayfs][containers]

Julia Evans explains how `overlayfs` -- a union filesystem -- powers containers and makes it much more efficient to build images from other images. Great read.

[make]: https://blog.mindlessness.life/2019/11/17/the-language-agnostic-all-purpose-incredible-makefile.html
[containers]: https://jvns.ca/blog/2019/11/18/how-containers-work--overlayfs/
