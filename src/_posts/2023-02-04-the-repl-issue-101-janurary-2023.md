---
layout: post
title: "The REPL: Issue 101 - January 2023"
date: 2023-02-04 11:51:45 -0800
categories:
- the repl
- databases
- rails
- ruby
excerpt_separator: <!-- more -->
---

### [CTEs as lookup tables][1]

Short and sweet. The syntax is nicer to read, and in my mind it fits better with the SQL mental model of relations.

### [Ransacking your password reset tokens][2]

The [ransack gem][4] is a popular ruby gem to add searching capabilities to a Rails application. This article describes, compellingly, how ransack by default is open to exploitation and can be used to reveal sensitive information in an application. This process reminds me about how Rails allowed (insecurely) mass-assignment of params, which later was changed to **not** allow any params, unless specifically permitted. That approach is possible with Ransack, too. For existing applications, it can lead to a lot of allow-listing.

### [Anti-Pattern: Iteratively Building a Collection][3]

It resonates with me that iteratively building an array feels wrong. But **why?**

The author states:

> What follows are some lengthy method definitions followed by rewrites that are not only more concise but also more clear in their intentions.

So... is clarity the key?

Brevity and clarity are great, but one of the things that motivates me to use functional approaches over iterations is to minimize mutation. Written in a functional style your code handles less mutation of data structures, which means that it handles less state. Handling state is were a lot of complexity hides, and the source of bugs. According to [Joe Amstrong][5], creator of Erlang:

> Mutable state is the root of all evil.

[1]: https://misfra.me/2023/ctes-as-lookup-tables/
[2]: https://positive.security/blog/ransack-data-exfiltration
[3]: https://thoughtbot.com/blog/iteration-as-an-anti-pattern
[4]: https://github.com/activerecord-hackery/ransack
[5]: https://softwareengineeringdaily.com/2015/11/02/erlang-with-joe-armstrong/
