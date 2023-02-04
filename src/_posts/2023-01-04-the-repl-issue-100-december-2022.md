---
layout: post
title: "The REPL: Issue 100 - December 2022"
date: 2023-01-04 14:37:07 -0800
categories:
- postgres
- sqlite
- productivity
excerpt_separator: <!-- more -->
---

### [Just Use Postgres for Everything][1]

Complexity can be reduced by having less dependencies and systems. Postgres is a fantastic technology, and getting better with every release. I've been doing what this article advocates for years: Using Postgres by default (e.g. JSON storage, back a job queue, full-text search), and only moving away when needed.

### [SQLite's automatic indexes][2]

Preetam Jinka explains how SQLite handles join on un-indexed fields: It creates a temporary index! This saves postgres from having to implement hash joins.

### [What I learned from pairing by default][3]

Eve Ragins talks about what he learned when pairing by default. I've done a fair amount of pairing, but my sweet spot is no more than 2 or 3 hours a day. After that it becomes to tiresome. There is some exploratory work that I also rather do by myself, to avoid having to talk through everything I am thinking.

[1]: https://www.amazingcto.com/postgres-for-everything/
[2]: https://misfra.me/2022/sqlite-automatic-indexes/
[3]: https://blog.testdouble.com/posts/2022-12-07-what-i-learned-from-pairing/
