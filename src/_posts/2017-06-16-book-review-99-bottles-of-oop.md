---
layout: post
title: "Book Review: 99 Bottles of OOP"
date: 2017-06-16 13:15:02 -0700
comments: true
categories:
- books
- ruby
- design  
---

*99 Bottles of OOP* [bills itself][book] as a practical guide to writing cost-effective, maintainable and pleasing object-oriented code -- otherwise known as "good" code. It delivers on that promise.

Sandi Metz ([often][1] [mentioned][2] [in][3] [this][4] [blog][5]) and Katrina Owen (also [previously][6] mentioned) team up to write this highly instructive guide. They use a simple coding exercise -- print out the lyrics to the 99 bottles of beer song -- to illustrate several different implementations and provide some critiques of them.

They go much father, though. By introducing a new requirement, they embark on a fascinating and painstaking refactoring process. By changing one -- and only one -- line at the time, they use their test suite as a safety net to *discover* abstraction hidding in the code. Slowly, they improve the code bit by bit, following Kent Beck's [advice][beck]:

> for each desired change, make the change easy (warning: this may be hard), then make the easy change

Often, refactoring and coming up with abstractions seems esoteric. Experienced engineers know how to do it, but often can't explain their process to more junior engineers. Worse, it's hard to express why one design is better than another. Sandi and Katrina provide some relief from the paralysis that can result from starting at a piece of code without knowing which is the correct abstraction that it needs. The prescribe to follow the **Flocking Rules**:

1. Select the things that are more alike.
2. Find the smallest difference between them.
3. Make the simplest changes that will remove the difference.

By example, the authors apply these rules to extract one abstraction after another. [Naming is still hard][naming], but is easier once the extraction has been made. Along they way they should how to judge code with facts (like cyclomatic complexity and the ABC metric), as opposed of just on opinion.

Overall, I learned a lot from this book. The examples are written in Ruby, but the syntax is so simple, that it can be easily understood by anyone already familiar with another programming language.

[1]: /blog/2012/11/27/book-review-practical-object-oriented-design-in-ruby-sandi-metz
[2]: /blog/2013/01/17/sandi-metz-rules
[3]: /blog/2013/12/11/sandi-metz-revised-rules
[4]: /blog/2015/02/03/the-repl-issue-6-january-2015
[5]: /blog/2015/03/03/the-repl-issue-7-february-2015
[6]: /blog/2013/08/16/exercism-practice-your-coding-technique
[beck]: https://twitter.com/kentbeck/status/250733358307500032
[naming]: https://twitter.com/secretGeek/status/7269997868
[book]: https://www.sandimetz.com/99bottles/
