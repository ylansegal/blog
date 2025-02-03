---
layout: post
title: "The REPL: Issue 125 - January 2025"
date: 2025-02-03 10:48:31 -0800
categories:
- the repl
- machine_learning
- rails
excerpt_separator: <!-- more -->
---

### [Cheating is All You Need](https://sourcegraph.com/blog/cheating-is-all-you-need)

Steve Yegge writes (a lot!) about AI. His take is very interesting: Basically LLMs are in a race to the bottom. Each LLM is not that different from the next. The important bit is about context: Providing the LLM with enough context to do the task at hand. I've only had limited experience playing around with LLMs, but I definitely think that they *only* work when they are provided enough context to perform the task at hand. Providing can be tedious. If you want it to help you write a unit test, well it needs access to the class in question. And it's collaborators. And the factories that the test uses. And so on. Copy/pasting all of that is a lot. The more interesting claims about AI I've seen are for tools that integrate with your editor (or IDE) to *provide* the context to the LLM.

### [Nearly All Binary Searches and Mergesorts are Broken](https://research.google/blog/extra-extra-read-all-about-it-nearly-all-binary-searches-and-mergesorts-are-broken/)

Interesting take about algorithm correctness: The author wrote a buggy implementation of a binary search in the Java language. And the bug, is the same one that his PhD teacher had in his book! The bug was for *some* ranges of inputs (not all), which is why it's so pervasive and hard to spot, until you specifically start to look for it.

> We programmers need all the help we can get, and we should never assume otherwise. Careful design is great. Testing is great. Formal methods are great. Code reviews are great. Static analysis is great. But none of these things alone are sufficient to eliminate bugs: They will always be with us. A bug can exist for half a century despite our best efforts to exterminate it. We must program carefully, defensively, and remain ever vigilant.

### [The Mythical IO-Bound Rails App](https://byroot.github.io/ruby/performance/2025/01/23/the-mythical-io-bound-rails-app.html)

The author makes good arguments that if Rails in the wild was really IO bound all the time, than the recent YJIT improvements in Ruby versions would not have resulted in reported ~25% improvements in real apps. The improvements suggests that a good chunk of the time *was* being spent in Ruby. He then goes to point out that actually measuring IO is complicated, and that CPU starvation can look like IO.
