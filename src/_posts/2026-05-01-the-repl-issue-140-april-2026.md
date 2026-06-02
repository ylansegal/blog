---
layout: post
title: 'The REPL: Issue 140 - April 2026'
date: 2026-05-01 09:30:55.000000000 -07:00
categories:
- the repl
- postgres
- machine_learning
- git
excerpt_separator: "<!-- more -->"
syndication_excerpt: |-
  - Keeping a Postgres queue healthy
  - Highlights from Git 2.54
  - Do I belong in tech anymore?
syndicated:
- platform: bluesky
  url: https://bsky.app/profile/ylan.segal-family.com/post/3mkslxkmqsb2a
  date: '2026-05-01 09:57:48 -0700'
---

# [Keeping a Postgres queue healthy — PlanetScale](https://planetscale.com/blog/keeping-a-postgres-queue-healthy)

Simeon Griggs explains the challenges and dynamics of queue workloads in Postgres. A job queue in Postgres is desirable because of transactionality, and because it spares you from maintaining a separate system. At a certain scale, though, it outpaces the database's ability to clean up after itself. I haven't evaluated PlanetScale's solution to the problem.

### [Highlights from Git 2.54](https://github.blog/open-source/git/highlights-from-git-2-54/)

`git` is my most used command. I'm glad to see the CLI still improving. `git history` looks genuinely useful for splitting or rewording commits. The new hook configuration also offers a much cleaner way to declare hooks -- clearly needed, judging by the many popular hook-management systems out there.

### [Do I belong in tech anymore?](https://ky.fyi/posts/ai-burnout)

Ky Decker writes a personal account of disillusionment with the tech sector. In the "The psychic toll of AI" section, Ky describes a thoughtless use of AI in his workplace, where critical thinking has gone out the window and AI is shoved everywhere. A harrowing account. I'm glad I'm not in that situation. In a short time, AI has changed how I plan features, explore alternatives, and code. Yet the technology has limitations and needs a human in the loop to check its output.
