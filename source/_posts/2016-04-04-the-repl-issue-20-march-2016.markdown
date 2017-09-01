---
layout: post
title: "The REPL: Issue 20 - March 2016"
date: 2016-04-04 09:35:00 -0700
comments: true
categories:
- the repl
---

### [How To Deploy Software][1]

Zach Holman writes and in-depth post about software deployment, based on his experience at Github - well known for their automated and frequent deployments to their production environment. Most of what is covered is applicable for web applications, but some of the concepts carry over to device applications.

### [Rebuilding Git in Ruby][2]

In this post, Joël Quenneville distills the basics of how the core `git` internals work. In order to illustrate, he reimplements in Ruby the basics of git: Initializing a repository, staging files and committing. This is a case of where powerful abstractions can compose to create a software system with capabilities seemingly far greater than the building blocks it relies on.

[1]: https://zachholman.com/posts/deploying-software
[2]: https://robots.thoughtbot.com/rebuilding-git-in-ruby
