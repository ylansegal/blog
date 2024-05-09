---
layout: post
title: "The REPL: Issue 107 - July 2023"
date: 2023-08-04 11:40:20 -0700
categories:
- the repl
- software
- postgres
excerpt_separator: <!-- more -->
---

### [The Day FedEx Delivered Its Promise](https://www.anaeo.com/fedex/)

The story is compelling. A small tweak has a big payoff. We'd all like to believe that we can do that in our own lives. It also rings as apocryphal, but I haven't actually checked. The takeaway is that incentives matter, and changing incentives changes behavior.

The more interesting question is: how do you find the correct incentives? Getting lucky is one way. Is there a systematic methodology to design and measure incentives? It also reminds me of the adage "You optimize what you measure". The measuring itself becomes an incentive.

### [Responding to “Are bugs and slow delivery ok?”](https://uselessdevblog.wordpress.com/2023/07/03/responding-to-are-bugs-and-slow-delivery-ok-the-blog-post-that-ive-hated-the-most-ever/)

This article responds to another article, about when it's OK to ship buggy software. I think the original was a marketing ploy by that author setting up a false dichotomy so that you would agree that you *do* need good quality. This author then misunderstands, I think, but it doesn't matter. The claim is that it is in fact OK to ship slow, with bugs because:

> I’ve seen (and wrote) some terrible quality code. Really bad stuff. Untested, most of it.
> In nearly every place I’ve worked at.
> I’ve seen enormous amounts of time wasted with testing for, or fixing, bugs.

> You know what I haven’t seen? not once in 15 years?
> A company going under.

There is lots of ways a company can have bad performance, without "going under". It's is a false dichotomy. Akin to dismissing all diseases because they are not deadly, glossing over the nuance that you can still suffer a lot without dying.

In any case, it's hard to think that a company like Apple would be the the most valuable company in the world, if they embraced shipping buggy software or hardware. A company can limp along and compensate, but not excel. Quickbooks comes to mind. Their software is the worst. Everyone I know that uses it hates it, but they are profitable. Why? Because they have captured the accountants market, and they make their clients use it. They survive like that, but I don't think they actually thrive.

### [Online Data Type Change in PostgreSQL](https://www.percona.com/blog/online-data-type-change-in-postgresql/)

This article does a good job at sequencing how to change a column type in postgres without locking the whole table. The temp table for keeping track of what needs to be backfilled works, but it can also be done without.

What was *not* discussed at all, is what happens to the application code in the meantime. Rails applications will see the new column an register it. The trigger takes care of writing the data for that column, but when we rename the columns in the last step (or delete them), we are changing the column information from under Rails's proverbial rug, which will cause exceptions. Solvable problems, if you are looking for them in the first place.
