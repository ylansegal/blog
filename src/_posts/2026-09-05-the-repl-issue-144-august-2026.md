---
layout: post
title: 'The REPL: Issue 144 - August 2026'
date: 2026-09-05 12:19:08.000000000 -07:00
categories:
- the_repl
- git
excerpt_separator: "<!-- more -->"
syndication_excerpt:
syndicated:
- platform: bluesky
  url: https://bsky.app/profile/ylan.segal-family.com/post/3mus7vkeyt22c
  date: '2026-09-05 12:33:52 -0700'
---

Today's REPL is different from most. I usually point to a few interesting articles. This time I found myself writing at length about a single one.

### [Accepting a messy git history](https://beza1e1.tuxen.de/git_two_users.html)

Andreas Zwinkau describes two kinds of git users: commit often, or rebase carefully. I don't see it as a choice between the two. It's more nuanced.

I do both. While developing, I commit whenever I reach a meaningful amount of work [^1]. Sometimes that's failing tests that expose a bug, so the red-green cycle lives in the history. Sometimes it's a class or module the feature needs but that isn't hooked up to the rest of the system yet. It's a thoughtful process, but it doesn't always leave a pristine history.

Before I open a pull request, I go through that history. Sometimes I took a path and later backtracked. A file might exist only in this branch because I decided the naming needed work. None of that helps anyone later, so I rebase and squash to present a better story in the pull request.

Once I open a pull request, I don't rebase, squash, or otherwise change the history. Not even squash merges. Once reviewers have commented, rewriting history creates more work for them. GitHub presents a "changes since your last review" button, which is extremely useful. A force-pushed rebase or squash destroys it, and the reviewer has to read the whole PR again. I care more about reducing friction with my teammates than about a pristine git history.

Is a pristine git history even worcth having?. Most arguments I've come across say a good history gives historical context about a code base. I agree, to a point. Commit messages that all say "fix code" help no one. But a squash-merged history *loses* the changes reviewers asked for. They live in the pull request, not in git. So does a history rewritten to look like the code arrived fully formed. I prefer the actual history to an abridged version.

As for stacked pull requests, I think a lot of folks miss the point. They *can* split a large change into smaller chunks for review, but in practice I use multiple PRs when I need to sequence deployments. For example, a PR that prepares the code for a column deletion, then a stacked PR with the migration that deletes it. Sometimes a conceptual unit of work has to ship in multiple PRs. That's different from a commit history that tells a story but can be deployed all at once. As for the "read the commits individually" argument: I've never been on a team that does that. Maybe because GitHub doesn't encourage it, but whatever the reason, I don't see it as a practical way to review PRs.

[^1]: This has changed somewhat with the use of agents.
