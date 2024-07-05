---
layout: post
title: "The REPL: Issue 118 - June 2024"
date: 2024-07-05 10:17:16 -0700
categories:
- the repl
- ruby
- rails
excerpt_separator: <!-- more -->
---

### [Better Know A Ruby Thing: On The Use of Private Methods](https://buttondown.email/noelrap/archive/better-know-a-ruby-thing-on-the-use-of-private/)

Noel Rappin writes thoughtfully about private methods. I actually approach writing classes in the opposite way that he does, and I also do it because of past experience. I currently work on a smallish team, but I used to work on a team that had ~200 engineers committing to the same monolith. Effectively, the cost of writing public-by-default methods was essentially the same as maintaining a library: It wasn't clear to me who would use my class, when, or how. My approach is private-by-default: Make the API as small as possible.

If, in fact, there is a future need to re-use some abstraction that is currently used in a private method, I am happy to refactor later and make that functionality available purposefully.

### [Inline RBS type declaration](https://github.com/soutaro/rbs-inline)

Experimental syntax, but this mode of type declarations are something I can get on board with!

Since it's using `#::` and `# @rbs` as special comments, they can probably be recognized by syntax highlighters and other tooling.

### [Lesser Known Rails Helpers to Write Cleaner View Code](https://railsdesigner.com/lesser-known-rails-helpers/)

I've been writing Rails for over 12 years, and some of these are new to me! I wonder if I'll remember that they exist next time I have opportunity to use them!
