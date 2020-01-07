---
layout: post
title: "The REPL: Issue 56 - April 2019"
date: 2019-05-06 18:00:59 -0700
comments: true
categories:
- the rep
excerpt_separator: <!-- more -->
---

### [Technical Debt Is Like Tetris][1]
Eric Higgins makes an analogy that resonates: Technical debit is like a Tetris. It accumulation can always be seen, but it not necessarily detrimental until there is enough of it. At some point it can make it impossible to make progress, or even to keep the game going. I guess starting a new game is equivalent for rewriting your software :-).

### [Storing UTC is not a silver bullet][2]

One doesn't have to program for long before encountering the sharp edges of date, time, and time zones handling. For a lot of use cases, storing date/time in UTC is a good solution. In this post, Jon Skeet explains why it doesn't solve *all* the possible problems. The biggest takeaway is that Time zone definition changes constantly, and if your code doesn't account for it explicitly, it will do so implicitly -- sometimes with unexepcted results.

### [Using GNU Stow to manage your dotfiles][3]

I manage my Unix dotfiles with care, manage them with source control, and take them with me from machine to machine. I spend a lot of time in my Unix environment and my configuration allows me to be productive. Until recently, I managed my dotfiles with a hand-crafted script that created symlinks. In the past I tried a few different solutions for the same problem, but nothing worked well for both files, directories and arbitrary locations. In this post, Brandon Invergo explains how to leverage a new-to-me utility: GNU `stow`. It's purpose is to manage symlinks, usually in the context of activating different version of the same software in the same system. It works great for dotfiles!


[1]: https://medium.com/s/story/technical-debt-is-like-tetris-168f64d8b700
[2]: https://codeblog.jonskeet.uk/2019/03/27/storing-utc-is-not-a-silver-bullet/
[3]: http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html
