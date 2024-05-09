---
layout: post
title: "The REPL: Issue 108 - August 2023"
date: 2023-09-02 10:14:05 -0700
categories:
- the repl
- bi temporal data
- rails
excerpt_separator: <!-- more -->
---

### [Eventual Business Consistency][1]

Kent Beck talks about [bi-temporal modeling](/categories/bi-temporal-data/). It's a topic I'm very interested in. I am glad that Ken Beck is talking about this: He has great readership and might make this a more mainstream technique. I am not sure about renaming it to "Eventual Business Consistency".

> However, I think part of the reason it hasn’t become more popular, given the benefits it brings, is just the name. Hence my proposed rebranding to “eventual business consistency”.

I don't see any rationale for this assertion. I doesn't ring true for me. Bi-temporal data/modeling seems like a fine name. Programmers regularly talk about polymorphism, inheritance, dependency injection, concurrency, parallelism. As far as I can tell, bi-temporal doesn't seem different than other technical jargon. I fail to see why it's a disadvantage.

If I had to guess, I think that he was right in the first place:

> Part of the reason it hasn’t taken off is because of the additional complexity it imposes on programmers.

Bi temporal modeling adds a *lot* of complexity. Most queries are "current" state queries, where `NOW()` can be used for both the validity range and the transaction range. The complexity comes from primary keys and foreign keys now needing to account for the ranges. It's solvable, but most databases (Postgres, MySQL) don't have first-class support for modeling like this. This probably could be solved with extension or application frameworks. I believe that could actually bring more usage.

Another barrier to entry, is that most applications are not designed with bi-temporal data in mind. Adding bi-temporal data to an existing model is more complicated and requires migrating data (and obviously not all data has been kept).

### [Just normal web things.][2]

I nodded along while reading. Users have expectation of how the web should work and what they can do with it: Copy text, open a new window, etc. Websites shouldn't break that!
Sometimes websites are really apps that have a different UX paradigm (e.g. a photo editor). Most of the website that are coded as "apps" -- and break web conventions -- could easily be standard CRUD web apps. Sigh.

### [Play in a sandbox in production][3]

Andy Croll advices to use `rails console --sandbox` in production, to avoid making unintended data changes.

The "why not" section is missing that opening a rails console with `--sanbox` opens a transaction that is rolled back after the console is closed. Long-running transactions can cause whole system performance degradation when there is a high load on the system.

When should you worry about this? Depends on your system. I've worked on systems where traffic was relatively low, and wouldn't be a problem. I've also worked in systems where a long-running transaction of only 1 or 2 minutes cause request queueing that would bring the whole system down.

Is there an alternative? Yes. Open a rails console using a read-only database connection (to a read replica or configured to be read-only against the same database). That is not as easy as `--sandbox`, but it can be as simple as setting a postgres variable to make the connection read only.

[1]: https://tidyfirst.substack.com/p/eventual-business-consistency
[2]: https://heather-buchel.com/blog/2023/07/just-normal-web-things/
[3]: https://andycroll.com/ruby/play-in-a-sandbox-in-production/
