---
layout: post
title: "The REPL: Issue 22 - May 2016"
date: 2016-05-31 09:15:29 -0700
comments: true
categories:
- the_repl
---

### [On Shells and Static Paths][1]

It turns out that at the top our bash scripts we should be using `#!/usr/bin/env bash` instead of `#!/bin/bash`. Jump the link for a good explanation on the UNIX specifications involved.

### [Elixir — Supervisors: A Conceptual Understanding][2]

Steven Leiva writes a supervisor from scratch. I find these king of pieces very useful. They de-mystify some of the technologies, explore what is under the hood and end up enhancing my understanding, making future use much easier.

### [The Straight Dope on Deprecations][3]

Last month, I [mentioned another article][5] by Richard Schneeman. Now, he is back with another in-depth, nuanced post about how to handle deprecations in libraries. Especially useful for library authors and mantainers, but good knowledge in general. The whole community gains when there are clear conventions around versioning, deprecation, support, etc. [@schneems][4] is doing a great service with his recent articles.

[1]: http://deftly.net/posts/2016-04-26-on-shells-and-static-paths.html
[2]: https://medium.com/@StevenLeiva1/elixir-supervisors-a-conceptual-understanding-ee0825f70cbe#.5yq63mrje
[3]: https://blog.codeship.com/the-straight-dope-on-deprecations/
[4]: https://twitter.com/schneems
[5]: /blog/2016/05/02/the-repl-issue-21-april-2016/
