---
layout: post
title: "The REPL: Issue 74 - October 2020"
date: 2020-11-03 10:47:28 -0800
categories:
- the repl
excerpt_separator: <!-- more -->
---

### [Introduction to the Zettelkasten Method][1]

The Zettelkasten method is a sort of personal note-taking method. This articles explains why the method is interesting in the first place, it's principles and a few possible ways of using it. I've been gravitating in the last few years to a similar method, which doesn't quite adhere to *all* the principles. I've long known that writing things down helps clarify your thoughts; having to articulate your thoughts, makes you a better thinker. It also helps with knowledge retention. What struck me most as I read this article is that there is another level of value that comes from the effect of capturing *more* things and *linking* thoughts together. That is what turns facts into knowledge: Knowing how it relates to other thoughts.

As I was reading, I noticed that I often capture thoughts in my [daily note][on_note_taking]. That is better than not capturing at all, but it doesn't make it discoverable in the future. Since reading the article, I've started creating separate notes for each individual "thought" and tagging it. I am also making an effort to link -- at the time of writing -- with other notes.

### [The Pyramid Principle][3]

Shiva Prabhakaran at Models HQ writes about the Pyramid Principle, which recommends that you start communicating with your answer/hypothesis first and then support it with arguments and data.

My natural instinct when speaking, is to do something similar to this recommendation (but not quite): Start with the answer, and then add context. This recommendation goes a bit further: Answer, summary, and then supporting arguments.

When writing, my instinct is more to start from the context, walk through the rationale and arguments, and then get to the conclusion. That follows my train of thought, which I expect my readers to follow. This article explains why it might be better to start in the other direction.

The recommendation comes from consulting companies and their communication with executives. Its applicability might be limited.

### [Rbspy][3]

This week I found myself working on optimizing the performance of a refactored Rails endpoint. I found `rbspy`:

> rbspy lets you profile Ruby processes that are already running. You give it a PID, and it starts profiling. It’s a sampling profiler, which means it’s low overhead and safe to run in production.

> rbspy lets you record profiling data, save the raw profiling data to disk, and then analyze it in a variety of different ways later on.

This made it painless to get data on a *running* process without much fuzz. It even generates [flamegraphs](https://rbspy.github.io/using-flamegraphs/).


[1]: https://zettelkasten.de/introduction/
[2]: https://models.substack.com/p/pyramid-principle
[3]: https://rbspy.github.io/
[on_note_taking]: {% post_url 2018-08-26-on-taking-notes %}
