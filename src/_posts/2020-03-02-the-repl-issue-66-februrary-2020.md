---
layout: post
title: "The REPL: Issue 66 - February 2020"
date: 2020-03-02 10:38:50 -0800
categories:
- the repl
excerpt_separator: <!-- more -->
---

### [Challenges with distributed systems][1]

Jacob Gabrielson about the challenges of distributed systems at Amazon. He comes up with failures modes inherent in _all_ distributes systems, and calls them the *eight failure modes of the apocalypse*. Engineering distributed systems is hard, being cognizant about all failure modes helps by providing some structure to tackling the problem.


### [Rails has added strict loading mode to prevent lazy loading][2]

Rohit Kumar points out that Rails 6.1 will add *strict loading* support. With it turned on, Rails will raise an error instead of allowing association lazy loading. I welcome this change. Lazy loading seems like a feature that speeds up development in Rails, but is the cause of N+1 queries. I have yet to work on Rails app that doesn't have performance issues because of this.

### [On recursive queries][3]

Egor Rogov gives an overview of the recursive syntax in SQL, and walks through a step-by-step example of how to write a useful, performant recursive query, that solves a realistic business-logic example.


[1]: https://aws.amazon.com/builders-library/challenges-with-distributed-systems/
[2]: https://blog.saeloun.com/2020/02/25/rails-strict-loading-mode-to-fix-n-1.html
[3]: https://habr.com/en/company/postgrespro/blog/490228/
