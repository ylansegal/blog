---
layout: post
title: "The REPL: Issue 110 - October 2023"
date: 2023-11-04 12:10:54 -0700
categories:
- ruby
- rails
- postgres
- tdd
excerpt_separator: <!-- more -->
---

### [Postgres Goodies in Ruby on Rails 7.1](https://www.crunchydata.com/blog/postgres-goodies-in-ruby-on-rails-7-1)

Rails 7.1 is out with some very interesting features for Potsgres users. Composite primary keys support in particular caught my eye: When partitioning tables, using a composite primary key that includes the partition key is a best practice. Now, Rails supports the composite primary keys in the model and associations (through `query_constraints`) ensuring that when reading from the table, the partition key is always used.

Improved support for CTEs is also welcome!

### [Writing Object Shape friendly code in Ruby](https://island94.org/2023/10/writing-object-shape-friendly-code-in-ruby)

It turns out that the way you structure classes (and more precisely variable instantiation) in ruby > 3.2 has performance implications. Ben Sheldon discusses how to structure classes to take advantage of those optimizations. It is an interesting demonstration on how code style and the ruby interpreter interact.

The article doesn't mention *how much* it impacts performance. I wonder: On a typical web request, how much can this save by structuring your classes for optimization?

### [The TLDR on Ruby's new TLDR testing framework](https://blog.testdouble.com/posts/2023-10-03-introducing-the-tldr-ruby-test-framework/)

> It’s called TLDR and it blows up if your tests take more than 1.8 seconds to run.

Testing is a near and dear topic to me. I have not tried this new framework, but I have some initial thoughts:
- 1.8s is not a lot of time for a whole test suite.
- Test that fast need to avoid database interactions at all costs. In my experience that leads to heavy mocking, which in turn can lead to unit test passing but the components break on integration.
- TLDR seems incompatible with large systems (e.g. majestic monolith). For good or bad.
- Pushing the envelope can lead to some great ideas. For example:

> TLDR automatically prepends the most-recently modified test file to the beginning of the suite

This is brilliant. I have a script that guesses which test files to run on a branch based on what changed in git. After reading this, I immediately incorporated ordering the files by modification date.
