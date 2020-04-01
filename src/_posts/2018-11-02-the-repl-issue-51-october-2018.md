---
layout: post
title: "The REPL: Issue 51 - October 2018"
date: 2018-11-02 11:31:27 -0700
comments: true
categories:
- the repl
excerpt_separator: <!-- more -->
---

### [The Architecture No One Needs][1]

Greg Navis discusses why he thinks single-page applications (SPAs) are almost always worse than traditional, multi-page web application. I tend to agree: Most of the time, it adds engineering complexity for not much benefit. I think this is particularly the case when using Elixir and Phoenix, since their performance is spectacular. Phoenix Channels already provide a way for updating content on a page without reloading, and the upcoming Live View promises to make it even better.

### [Elapsed time with Ruby, the right way][2]

This post by Luca Guidi explains with great detail how calculating elapsed time in Ruby can have it's pitfalls. The TLDR:

```ruby
## Don't do this:

starting = Time.now
# time consuming operation
ending = Time.now
elapsed = ending - starting
elapsed # => 10.822178


## Do this:
starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
# time consuming operation
ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
elapsed = ending - starting
elapsed # => 9.183449000120163
```

### [Automate Repetitive Tasks with Composed Commands][3]

In this post, the [[Atom]] team explains how you can create composed commands from existing commands already available in your editor. This feature seems great for automating tasks. I haven't composed any commands of my own just yet, but I think this is a great addition.

[1]: https://www.gregnavis.com/articles/the-architecture-no-one-needs.html
[2]: https://blog.dnsimple.com/2018/03/elapsed-time-with-ruby-the-right-way/
[3]: https://blog.atom.io/2018/10/09/automate-repetitive-tasks-with-composed-commands.html
[4]: https://atom.io
