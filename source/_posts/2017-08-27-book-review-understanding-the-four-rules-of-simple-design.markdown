---
layout: post
title: "Book Review: Understanding the Four Rules of Simple Design"
date: 2017-08-27 15:22:06 -0700
comments: true
categories:
- books
- design
- ruby
---

*Understanding the Four Rules of Simple Design* by Corey Haines is a book about how to approach software design from a perspective of his years of the authors involvement in [Code Retreats][cr]. A Code Retreat is a day-long practice session for software developers where they can explore different ways of building software by practicing deliberately without the pressure of having to deliver production code. I've previously written about my [experience in a code retreat][cr_post].

The book uses the same base example that code retreats do: Conway's Game of Life. This example is specifically chosen because the rules are simple enough to understand quickly, yet it possible to write an implementation in many different ways with interesting tradeoffs.

The 4 rules of simple design, first enumerated by Kent Beck are presented in simplified form as:

1. Test Passes
2. Express Intent
3. No Duplication (DRY)
4. Small

Each of this rules is expanded on in detail with plenty of examples. One of my favorite quotes:

> In the end, most design guidelines are best internalized and applied subconsciously.

This books converges on many of the better patterns that I like about the Ruby community: Outside-in test-driven development, writing small intention revealing methods, consciously think about what each object's public API and avoiding over-designing for a future that may not materialize. I enjoyed reading it very much.

Links:
------

- [Publisher](https://leanpub.com/4rulesofsimpledesign)

[cr]: http://coderetreat.org/
[cr_post]: /blog/2015/11/17/my-global-day-of-code-retreat/
