---
layout: post
title: "The REPL: Issue 109 - September 2023"
date: 2023-10-04 12:11:12 -0700
categories:
excerpt_separator: <!-- more -->
---

### [YJIT is juicy!](https://twitter.com/dhh/status/1707084949281706199)

I've seen some recent post on social media about the great performance of Ruby + YJIT. It's time to give a try!.

I got it working locally with `asdf`:

```
$ asdf install rust 1.72.1
$ export ASDF_RUST_VERSION=1.72.1
$ export RUBY_CONFIGURE_OPTS=--enable-yjit

$ asdf install ruby 3.2.1
$ asdf shell ruby 3.2.1
$ ruby --yjit -v
ruby 3.2.1 (2023-02-08 revision 31819e82c8) +YJIT [arm64-darwin22]
```

### [Why You Might Not Want to Run Rails App:update](https://www.fastruby.io/blog/why-you-might-not-want-to-run-rails-app-update.html)

The author points out that `rails app:update` should be use with caution, because it might make unwanted changes to your application or remove manually added configuration. Fair enough. What I don't understand is the remedy: **not** to use it! That is what version control is for! I've upgraded multiple apps, multiple times using `rails app:update`. In every case, before committing the changes to version control I inspect each one and make an informed decision if I want to keep them or not.
