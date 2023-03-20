---
layout: post
title: "TIL: rails restart"
date: 2023-03-20 16:52:32 -0700
categories:
- rails
excerpt_separator: <!-- more -->
---

I first started writing Rails in 2010. Today I learned on the [Ruby on Rails Blog](https://rubyonrails.org/2023/3/18/this-week-in-rails-testfixtures-fixture_path-deprecation-findermethods-find-support-for-composite-primary-key-values-87e6e69a) that you can restart a running server in development with:

```
$ bin/rails restart
```

Up until today, I always quit my server (ctrl-c) and restarted when I wanted to pick a change that won't be hot-reloaded (e.g. a change to an initializer). This works, but it is slower, especially when I am using [foreman][foreman] to start a fleet of processes (e.g. webpacker, background workers).

Learning is a life-long process.

[foreman]: https://github.com/ddollar/foreman
