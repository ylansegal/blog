---
layout: post
title: "The REPL: Issue 8 - March 2015"
date: 2015-04-01 08:41:40 -0700
comments: true
categories:
- the repl
---

### [Turning The Database Inside Out With Apache Samza][1]

Based on a talk at Strange Loop 2014, this post was eye-opening. Although it's supposed to be about Apache Samza, most of the talk is devoted to talking about databases in general and what they are good at: Keeping global state, replication, secondary indexing, caching, and materialized views. This high-level view provided me with a lot of new perspective of how to think of databases. The many illustrations in the article are beautiful. Please go and read.

### [Your Most Important Skill: Empathy][2]

The legendary Chad Fowler makes the case that empathy is a skill that everyone will benefit from developing further. Provides great list of why that is. Most importantly, he also details **how** to practice.

### [Git From The Inside Out][4]

Git has often been criticized for having an inconsistent interface and leaking unneeded abstractions to the user. Some of that criticism is warranted. Nonetheless, `git` is one of my favorite programs. I use it hundreds of times throughout the day, always on the command-line, complemented by `tig`, the [ncurses client for git][4]. This article talks about the internals of `git`: How it stores data on disk for commits, trees, objects, tags, branches, etc. It is well written, well organized and a pleasure to read. If you read this guide, it will make it easier for you to interact with `git` because you will understand it's intrenals. However, I think you should read it because it shows how great functionality can be achieved with software with minimal dependencies and using only the local filesystem as a data store.

[1]: http://blog.confluent.io/2015/03/04/turning-the-database-inside-out-with-apache-samza/
[2]: http://chadfowler.com/blog/2014/01/19/empathy/
[3]: https://codewords.recurse.com/issues/two/git-from-the-inside-out
[4]: http://jonas.nitro.dk/tig/
