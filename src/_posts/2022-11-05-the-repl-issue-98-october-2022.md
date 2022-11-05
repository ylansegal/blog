---
layout: post
title: "The REPL: Issue 98 - October 2022"
date: 2022-11-05 11:36:07 -0700
categories:
- the repl
- postgres
- git
- ruby
excerpt_separator: <!-- more -->
---

### [Rebase dependent branches][1]

Taylor Blau at the GitHub blog points highlights a new feature `git` (v2.38) that I am super excited about. You can now `git rebase --update-refs`. Since reading that, I've already saved a lot of time (and minimized mistakes) when working on a set of branches that build on each other.

### [Partitioning in Postgres, 2022 edition][2]

Brandur highlights that Postgres has made great usability improvements to partitioning over the last few years. It is now relatively easy to take advantage of it.

### [Add Data class implementation: Simple immutable value object][3]

An new immutable value object, `Data`, has been merged into Ruby for release soon. It's stricter than a `Struct`, which in many cases is exactly what you need from a value object.

[1]: https://github.blog/2022-10-03-highlights-from-git-2-38/#rebase-dependent-branches-with-update-refs
[2]: https://brandur.org/fragments/postgres-partitioning-2022
[3]: https://github.com/ruby/ruby/pull/6353
