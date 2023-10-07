---
layout: post
title: "Book Review: A Philosophy of Software Design"
date: 2023-10-07 09:39:44 -0700
categories:
- books
- software
- design
excerpt_separator: <!-- more -->
---

### by ReJohn Ousterhout

This book focuses on software design, identified as a continuos process that spans the complete lifecycle of a software system. The first part of the book proposes that the main issue in software design lies in managing complexity.

> If a software system is hard to understand and modify, then it is complicated; if it is easy to understand and modify, then it is simple.

The rest of the book are a collection of principles, techniques, and heuristics to help remove or hide the complexity, replacing it with a simper design.

> It is easier to tell whether a design is simple than it is to create a simple design,

Probably the most salient piece of advise is that "modules should be deep": A module is deep when it provides a narrow interface to it's callers that provides a lot of functionality that abstracts away the details of the implementation.

> Adding garbage collection to a system actually shrinks its overall interface, since it eliminates the interface for freeing objects. The implementation of a garbage collector is quite complex, but that complexity is hidden from programmers.

Overall, I found the books worthwhile. Especially the attitude that the overall design of a system is constantly shifting. Individual programmers add or remove to the complexity in small increments every time they make changes to the system. Cutting corners very often, will leave the code in a state that is hard to recover from.

My own attitudes to software design align well with Ousterhout's except for comments and tests. The author uses comments as a design aid: Writing interface comments first, before implementing any code, so that they guide the design. It gets the programmer thinking about how the module will be used, instead of how it will be implemented. As for tests:

> The problem with test-driven development is that it focuses attention on getting specific features working, rather than finding the best design.

I wholeheartedly agree with the goal of writing comments first: Outside-in thinking results in better design. Focusing on how a module will be used from a caller's perspective improves the module's API. Sometimes comments can serve that purpose, but I think that the author misses the point that test-driven design (TDD) accomplishes that purpose as well. When you write your tests first, by definition you are forced to think how the module will be called, because the test itself uses it! In fact, TDD works best when you start writing tests in the outermost layer of your system and work your way inwards. It gets some time getting use to because the outermost test wont pass until the innermost implementation is complete. The gain is that those tests inform the design through the layers. As for the criticism about TDD being to focused on getting specific features working, I think this is a "shallow" TDD. TDD is typically a red-green-refactor loop. Red: write a failing test. Green: make it pass. Refactor: improve the design. I would agree with Ousterhout if we stopped at red-green, but the last step, the refactor, is what makes it complete: Red improves the API design, Green makes it correct, Refactor improves the internal design.


Links:
- [Author's Website](https://web.stanford.edu/~ouster/cgi-bin/aposd.php)
