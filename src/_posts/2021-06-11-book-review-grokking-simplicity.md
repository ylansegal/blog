---
layout: post
title: "Book Review: Grokking Simplicity"
date: 2021-06-11 14:33:35 -0700
comments: true
categories:
- books
- software
excerpt_separator: <!-- more -->
---

### Taming complex software with functional thinking
### by Eric Normand

This book explores functional programming in a way that is very approachable for those starting out on that discipline, yet is still worthwhile for people that are already somewhat familiar with functional paradigms.

In Part 1, Normand explores the the difference between data, calculations and actions. Calculations are more traditionally called pure functions: They only depend on the inputs, and produce the same results when run multiple times. Actions are more traditionally called impure functions: The produce side-effects, and their results depend on where they were called. This key distinction is what the rest of the book is based on.

Part 2 explores functional abstractions for iteration, `map`, `reduce`, `filter`, and how to work with nested data structures. It then it goes on to derive several concurrency primitives and apply them. Concurrency analysis can be quite tricky, but was made very approachable by the use of timeline diagrams.

Overall, I though this book was worth it. The examples where concise enough to understand, but not trivial. The code in the book is written in Javascript, a language a I don't write or know very well: It was not a problem. In fact, it gave me an opportunity to reflect on what affordances Ruby provides that are very functional in nature.

I thought it was very neat that the author cautions the reader about the pitfalls of over-enthusiasm for newly acquired skills, and provides guidance on how to avoid it. There is also plenty of ideas on how to continue the functional journey. The last chapter even lists out what the author thinks the biggest takeaways are:

1. There are often calculations hidden in your actions
2. Higher-order functions can reach new heights of abstraction
3. You can control the temporal semantics of your code

Links:
- [Grokking Simplicity](https://grokkingsimplicity.com/)
