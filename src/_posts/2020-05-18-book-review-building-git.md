---
layout: post
title: "Book Review: Building Git"
date: 2020-05-18 13:55:17 -0700
comments: true
categories:
- books
- databases
excerpt_separator: <!-- more -->
---

`git` is a widely successful version control system, it's used in software companies large and small. It's distributed nature changed software development in many ways. In `Building Git`, James Coglan re-implements a subset of `git`'s functionality from the ground up, using Ruby, which has a large standard-library and is higher-level than the original C.

`git` itself is a large project with a lot of functionality. The book covers a lot of ground, in a step-by-step fashion. Each line of code is explained both conceptually and syntactically.

<!-- more -->

Some of the most interesting things I learned:

- Objects in `git` are represented by a hash of their content. They are also immutable. Since their content never changes, neither does their hash. This powers `git`'s ability to capture the state of every change in the project, without having multiple copies of the same content. I found this to be a clever use of cryptography.

- My interactions with `git` are typically around file diffs. I assumed that is what `git` stored. In fact, it stores blobs with the content and mode of files, trees with the heirarchy of files and folders in the project, and commits with metadata about the tree. Every commit in `git` points to a full representation of the project. Along the way I got to dive deeper into nested tree structures.

- Unix-related content: Writing files atomically, lock files, files modes, guarantees (or lack of) of system calls, etc. In later chapters, the distributed nature of `git` is implemented by taking advantage that `ssh` can pipe input and output between a local and remote processes. This lets us build abstractions that hide all the complexity involved in implementing network protocols.

- Graph theory: Generating diffs is not quite as straight forward as I imagined. Coglan does not shy away from the explanation of the theory, or rolling up the proverbial sleeves and writing the algorithm implementation.

- `git` optimizes object transfer by calculating deltas between objects and transfering in packs. Those packs are sometimes stored as-is on disk. `git` then deals with reading objects from it's database from "loose" vs "packed" storage.

Each chapter includes extensive references of the topics covered, as good as I've seen in any other technical book.

I enjoyed -- and learned a lot from -- this book.

#### Links:
- [James Coglan's Website](http://jcoglan.com/)
- [Ebook Storefront](https://shop.jcoglan.com/building-git/)
