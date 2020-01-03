---
layout: post
title: "The REPL: Issue 64 - November 2019"
date: 2019-12-04 10:48:13 -0800
excerpt: Git from the inside out. Code less, engineer more, Your Makefiles are wrong
categories:
- the repl
---

### [Git from the inside out][git]

In this essay, Mary Rose Cook explains how `git` works, focusing on the graph structure that underpins it and governs its behavior. `git` is a powerful piece of software, and digging into how it's designed thought me a lot.

### [Code less, Engineer more][code_less]

Liz Fong-Jones writes about how effective software engineering teams become more effective: Writing less software. The premise is that the focus should be on the impact of the work, not how much code we write. Build what you must, buy what you can, and write it all down. Custom software should be a last, rather than first, resort.

A lot of this article resonates with me, especially the part about writing everything down. I've come to believe that documenting how and why you made a decision is as important as the decision itself. There will come a time when another engineer will ask, "Did you consider X or Y?". The decision record will answer that question, and eliminate much bike-shedding.

### [Your Makefiles are wrong][make]

Jacob Davis-Hansson shares his strong opinions on writing Makefiles. `make` was obscure to me for a long time. Its not common knowledge among rubyists, but I've come to appreciate it more as a generic build system, especially for file-oriented tasks. In this post, Jacob explains his preferred defaults. I found the use of sentinel files particularly useful.


[git]: https://codewords.recurse.com/issues/two/git-from-the-inside-out
[code_less]: https://increment.com/teams/code-less-engineer-more/
[make]: https://tech.davis-hansson.com/p/make/
