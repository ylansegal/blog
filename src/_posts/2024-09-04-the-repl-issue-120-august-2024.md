---
layout: post
title: "The REPL: Issue 120 - August 2024"
date: 2024-09-04 19:24:12 -0700
categories:
- the repl
excerpt_separator: <!-- more -->
---

### [Structure Your ERb and Partials for more Maintainable Front-end Code in Rails](https://garrettdimon.com/journal/posts/erb-partials-helpers-and-rails)

Interesting exploration of how to write better ERB views in Rails. One the one hand, adding ERB tags and interspersed Ruby code in HTML is not optimal. On the other extreme, is generating everything in Ruby with `tag` helpers, which is also less than optimal. No matter where you land, it seems that one needs to know both HTML, ERB and some Ruby DSL to write views, with an eye to what HTML will be generated.

### [actual_db_schema: Wipe out inconsistent DB and schema.rb when switching branches](https://github.com/widefix/actual_db_schema)

Interesting library. It attempts to solve the issue of jumping between multiple branches in Rails code bases and the DB schema getting out of sync. I have not used it, and can't say that I've struggled much with this problem. What I do struggle with is `structure.sql` conflicts of different branches all wanting to insert their migration number in the same spot.
