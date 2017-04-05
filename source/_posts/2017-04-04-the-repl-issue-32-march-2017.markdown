---
layout: post
title: "The REPL: Issue 32 - March 2017"
date: 2017-04-04 20:12:45 -0700
comments: true
categories:
- the_repl
---

### [Use the Unofficial Bash Strict Mode (Unless You Looove Debugging)][bash]

Bash is ubiquitous. Even [Windows runs it now][windows]. Often, it's the minimum common denominator you can expect a computer to have, without needing to install extra dependencies, which is why I often find myself writing bash scripts. In this article, Aaron Maxwell explains how to set a few options that will make it easier to avoid bash's many [pitfalls][pitfalls].

### [Validation, Database Constraint, or Both?][validation]

Derek Prior brings a well-articulated argument of when to use Rails validations and when to rely on database constraints. His advice is solid, for Rails, which doesn't handle constraint violation in the database well. After reading this article, I found out that [Ecto][ecto] -- an Elixir database wrapper -- *does* handle database constraints and makes them errors to the rest of the application. I wish Rails had that!

### [So you want to be a wizard][wizard]

Julia Evans made available a transcription of a keynote talk she gave recently. I really liked how show approached learning and breaking down big problems into manageable pieces. At some level, what she proposes is basic curiosity, without getting hung-up on your current level of understanding. Do you need to debug tcp networking in Linux, but don't know about it? Read some books on it. Is that not enough? Open up the source code and read that. Inspiring, yet refreshing. We can all learn anything, as long as we do it methodically and with dedication.

[bash]: http://redsymbol.net/articles/unofficial-bash-strict-mode/
[validation]: https://robots.thoughtbot.com/validation-database-constraint-or-both
[wizard]: http://jvns.ca/blog/so-you-want-to-be-a-wizard/
[windows]: https://msdn.microsoft.com/en-us/commandline/wsl/about
[pitfalls]: http://mywiki.wooledge.org/BashPitfalls
[ecto]: https://hexdocs.pm/ecto/Ecto.Changeset.html#module-validations-and-constraints
