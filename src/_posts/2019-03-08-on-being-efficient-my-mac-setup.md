---
layout: post
title: "On Being Efficient: My Mac Setup"
date: 2019-03-08 13:10:41 -0800
comments: true
categories:
- productivity
---

As a Software Engineer, I spend most of my day working on a computer. Over the years, I've come to customize my setup to align better to the way I work and become more efficient. Efficiency is important because of the time you save, but not because you can do *more* with the time saved. It's allows you to keep focus on what you want to accomplish, instead of the mechanics of accomplishing it.

The following describes what I use on my Mac, but the principles apply to any operating system with a graphical interface. The metaphors they use are mostly the same: desktop, windows, application, a dock, etc.

## Application Launcher

I launch apps through an application launcher. It involves a keyboard shortcut to invoke the launcher, typing a few keys (usually 1 to 3) to fuzzy find the app I am looking for, and hitting enter. For me, typing 3 to 5 keys is very fast. I have been using [Alfred][alfred] for many years, but I've know people that thing the built-in Spotlight works just as well for this purpose.

## Switching Applications

MacOS (formerly OS X) includes a keyboard shortcut to switch applications: `cmd + tab`. Hitting it once and releasing switches you immediately to the last application used. It use this the most to switch back-and-forth between my editor and terminal, documentation and editor, etc.

Hitting `cmd+tab`, but keeping `cmd` pressed, brings up a modal list of the icons of all running application, ordered by how recently they have been used. While still holding `cmd`, pressing `tab` moves the selector to the next app in line (`shift + tab` moves back one spot). When `cmd` is let go, the selected app moves into focus. In this way, it becomes really fast to switch to another running application.

Alternatively, instead of finding the running app, I sometimes just use the application launcher. If the application is already running, it just switches to it.

For applications that use more than one window, you can use <code>cmd + `</code> to cycle between them. I use this often when I have more of one window for my text editor.

## Hide the Dock

I don't use my Dock. I have it set vertically to the far right of my screen and it's hidden by default, unless I move my mouse over it. This doesn't happen a lot, and usually it's by mistake. If there was a way to completely turn it off, I would.

As far as I can see, the main raison d'être for it is to launch favorite applications (see above), to switch applications (see above), or to see app badges (e.g. unread count for email). I limit aggressively the number of badges I allow in my applications. For those that I do use, it's enough for me to see them when switching applications.

As a side benefit of not having a permanent Dock, is that I get some of my screen real-estate back.

## Clipboard History

The built-in clipboard works very simply: When you paste `cmd + v` it inserts the last thing you copied `cmd + c` or cut `cmd + x`. A clipboard with a history, maintains a history off what you have copied and allows you pasting from it. This is one of those things that after using for a short while you wonder how you ever managed without.

Alfred provides that functionality for me as well. It's implementation is particulary nice, since it doesn't modify the standard paste command. Instead, it has a keyboard shortcut to open the history and a fuzzy finder to find entries. This works really well. A particularly nice touch is that it's configurable to *not* add things to the history from an application, like a password manager.

## Windows Tiling

The traditional way of positioning and sizing windows in MacOS is by using the mouse. It's slow and difficult to get just right. A window-tiling application let's you snap your windows into predefined positions. I use 3 sizes: Full screen*, half-screen vertical, third-screen vertical. I align them left, right, or centered as needed.  My preferred tool is [Spectacle][spectacle] which allows configuring all of this with keyboard-shortcuts.

I don't use MacOS full-screen mode: It removes the menu bar, which I like. More importantly it has an animation going to and from that is slower than just switching applications. I find that distracting. Instead I use Spectacle to enlarge the screen to fill the screen (equivalent of `option`-clicking on the green dot on a standard Mac window).

## Shortcuts for Text Editing

Last, but not least. I type a lot of text: Code, emails, ticketing systems. wikis, GitHub, etc. By default, all Mac text input areas allow the use of the same [text editing shortcuts][apple]. For example, moving to the begging of the current line (`cmd + left-arrow`), moving back a word (`option + left-arrow`), delete previous word (`cmd + delete`), etc. Those shortcuts make text editing much faster. Knowing those shortcuts is one of the reason why [I *don't* learn vim][forget].

---

Customizing your working environment, even in small ways can have a big cumulative effect. I don't recommend trying *all* of the above at once, but focusing on one at the time. Try it out for a while and tweak to your liking until it feels like a natural part of your workflow. For me, that can be anywhere from 2 to 4 weeks.



[alfred]: https://www.alfredapp.com/
[spectacle]: https://www.spectacleapp.com/
[apple]: https://support.apple.com/en-us/HT201236
[forget]: /blog/2013/04/22/forget-vim-learn-your-os-shortcuts/
