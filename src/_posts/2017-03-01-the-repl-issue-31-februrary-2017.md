---
layout: post
title: "The REPL: Issue 31 - Februrary 2017"
date: 2017-03-01 08:52:27 -0800
comments: true
categories:
  - the repl
excerpt_separator: <!-- more -->
---

### [Online migrations at scale][migrations]

Performing database migrations -- changes in the underlying schema -- is a necessity for many web systems, usually because they don't want to disrupt customer traffic. This post described how they solve this at Stripe. In my team, we follow a similar approach, but instead of dual-writing, we solve the problem by dual-reading. In any case, I commend Strip and other companies like it for detailing their successes in articles like these. The whole software engineering community gains.

### [The Security Impact of HTTPS Interception][interception]

In this fascinating article, researches from academics and industry detail how they went about measuring the use  HTTPS interception products and it's impact on security. HTTPS interception is usually deployed by IT systems so that they can decrypt HTTPS traffic and scan it. Essentially, it's like a man-in-the-middle attack that the user consents to. Not surprisingly, in most cases, the use of HTTPS interception results in downgraded security.

### [Software Engineering at Google][google]

Fergus Henderson describes Google's key software engineering practices. There are great insights into their process and approach, as would be expected from one of the most successful software companies today. It includes things like how they store their source code, which languages they use, their build system, code review process, debugging and profiling, 20% investment time and project and people management. Not every company can or should adopt all their practices, but most would benefit from *some* of them.

[migrations]: https://stripe.com/blog/online-migrations
[interception]: https://jhalderm.com/pub/papers/interception-ndss17.pdf
[google]: https://arxiv.org/pdf/1702.01715.pdf
