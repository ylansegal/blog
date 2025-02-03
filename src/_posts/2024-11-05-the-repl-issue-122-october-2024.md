---
layout: post
title: "The REPL: Issue 122 - October 2024"
date: 2024-11-05 16:06:28 -0800
categories:
- the repl
- postgres
- bi temporal data
- ruby
excerpt_separator: <!-- more -->
---

### [Waiting for PostgreSQL 18 – Add temporal PRIMARY KEY and UNIQUE constraints](https://www.depesz.com/2024/09/30/waiting-for-postgresql-18-add-temporal-primary-key-and-unique-constraints/)

In this article, and [a follow up](https://www.depesz.com/2024/10/03/waiting-for-postgresql-18-add-temporal-foreign-key-contraints/) we learn about upcoming changes to Postgres 18 that will make [temporal modeling](/categories/bi-temporal-data/) much easier. A welcome change. Maybe soon after that we can get libraries to leverage it in popular web frameworks.

### [Rightward assiggment in Ruby](https://ruby.social/@davetron5000/113362613406267986)

It's now possible to use rightward (`->`) assignment in Ruby. The tweet talks about using it in "pipelines":

```ruby
rand(100)
  .then { _1 * 2 }
  .then { _1 -3 } => value

value # => 7
```

I am very fond of pipelines like that, but feel that the `=>` is not very visible. What I want to write is:

```ruby
rand(100)
  .then { _1 * 2 }
  .then { _1 -3 }
  => value
```

But that doesn't work, because the parser balks. I can use a `\`, but that makes it awkward:

```ruby
rand(100)
  .then { _1 * 2 }
  .then { _1 -3 } \
  => value

value # => 87
```

### [Goodhart's Law Isn't as Useful as You Might Think](https://commoncog.com/goodharts-law-not-useful/)

> when a measure becomes a target, it ceases to be a good measure

Long dive into concepts from operations research that go deeper than the pithy "law" and explain the mechanisms at play.
