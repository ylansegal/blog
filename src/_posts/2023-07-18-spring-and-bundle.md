---
layout: post
title: "Spring and Bundler"
date: 2023-07-18 15:16:13 -0700
categories:
- rails
excerpt_separator: <!-- more -->
---

I was trying to update `rails` in one of my projects recently. The command I ran was not quite right, so I wanted to discard changes to `Gemfile.lock`

I kept doing:

```
git restore Gemfile.lock
```

But the git reported the file as still dirty, and the unwanted changes were still there. I couldn't understand what was going on!

Eventually, I noticed that:

```
git restore Gemfile Gemfile.lock
```

worked. Then it hit me. A `spring` server was still running an apparently running `bundle install` whenever the `Gemfile` changed, which was regenerating my unwanted changes as soon as I restored them with `git`.

I guess for some use cases this quiet behavior helps. In my case, I wanted to run a particular bundle update:

```
$ bundle update rails --conservative --patch --strict
```

`spring`. Sigh.
