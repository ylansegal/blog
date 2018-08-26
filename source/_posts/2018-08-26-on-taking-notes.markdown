---
layout: post
title: "On Taking Notes"
date: 2018-08-26 13:44:13 -0700
comments: true
categories:
  - productivity
---

For over a year now, I've started taking methodical notes as I go about my daily work as a Software Engineer. I find the process worthwhile.

## Reasoning

As I work on my daily tasks, I keep a note with my current plan and findings along the way. The very act of writing things down forces my thoughts to be more concrete. Putting my thoughts into words makes my assumptions explicit, often resulting in illuminating any gaps in reasoning. I find this is very similar to ["rubber ducking"][rubber].

## Reference

Taking good notes makes it easier to find the at a later time and use as reference. I find that there is no need need for specific tagging and organizing. Simple text search (`grep`) is enough to find previous content quickly. I find that I now regularly rely on being able to go back to my previous notes.

## Learning

When learning new tools, writing down specific instructions, CLI commands, etc helps cement the new knowledge. My preferred style of learning usually a mix of learn-by-doing enhanced by documenting the steps I took.

## How I Take Notes

- *Markdown*: I prefer a plan text format. I favor markdown because of it's simplicity and support for code blocks with syntax highlighting and checklists. It's also becoming ubiquitous in many tools I use.
- *Atom*: My current editor of choice. A few plugins make it particularly useful: [pipe][pipe] for executing against external commands, [wikilink][wikilink] for lightweight linking between notes.
- *Synching*: My notes are regular files, so they can be synched with any service (eg. Dropbox, iCloud, etc). I usually don't need my notes on my phone, but those services makes them available when I do.
- *Daily Note*: I usually start a fresh notes each day. It's like a dashboard of all the things I have going on. It's pre-populated with the items from the previous workday that were not completed (in Franklin Covey style). It serves as a scratchpad too. I link to notes that are more in depth for specific projects or tickets.
- *Weekly Note*: At the end of each work week I conduct a personal retrospective and write down my thoughts. It helps with keeping a big picture of what I am working on and my effectiveness at work.

I've found that t first taking lots of notes felt tedious. Now, I feel that it's very helpful to my daily tasks. I recommend it!

[rubber]: https://en.wikipedia.org/wiki/Rubber_duck_debugging
[wikilink]: https://atom.io/packages/wikilink
[pipe]: https://atom.io/packages/pipe
