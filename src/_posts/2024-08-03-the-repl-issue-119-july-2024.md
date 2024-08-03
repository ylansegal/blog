---
layout: post
title: "The REPL: Issue 119 - July 2024"
date: 2024-08-03 08:50:02 -0700
categories:
- the repl
excerpt_separator: <!-- more -->
---

### [Entering text in the terminal is complicated](https://jvns.ca/blog/2024/07/08/readline/)

Most of the things that I associate with "usable" CLIs actually comes from `readline`. TIL that you can wrap anything with readline! `rlwrap nc`. It doesn't seem to be installed on my Mac, by default though.

### [PostgreSQL INSTEAD OF Triggers](https://www.postgresqltutorial.com/postgresql-triggers/postgresql-instead-of-triggers/)

I've been working with Postgres triggers recently. They are immensely powerful, but I find the syntax hard to get used to, and the manual has limited examples. In particular this tutorial shows a use of `RETURNING ... INTO` to put a value into a variable that made it much easier to achieve what I wanted, instead of a chain of CTEs with `INSERT INTO` that was becoming unwieldy.


### [Event sourcing for smooth brains: building a basic event-driven system in Rails](https://boringrails.com/articles/event-sourcing-for-smooth-brains/)

I don't consider what this article described to be event sourcing. It's a light event system in Rails, which is great, but not exactly event sourcing.

In event sourcing (as understood by most of the literature), the event records are the source of truth, and by "applying" those events you get the current state of the system. What they describe is not that. The system in the article has events and subscribers that act on those events, and the state of the system is maintained separately from the events.

In trying to simplify, they threw out some of what the event sourcing typically consider the most useful parts. Basically, they kept a pub/sub system hooked into `after_commit` hooks. Useful, but not what is described on the tin.
