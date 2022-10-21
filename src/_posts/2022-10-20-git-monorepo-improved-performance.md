---
layout: post
title: "Git Monorepo Improved Performance"
date: 2022-10-20 17:30:44 -0700
categories:
- git
excerpt_separator: <!-- more -->
---

`git` recently shipped some performance improvements when working with large repositories, as [announced][1] on the GitHub blog.

I tested in a large repository. With default configuration:
```
$ time git status
On branch master
Your branch is behind 'origin/master' by 686 commits, and can be fast-forwarded.
  (use "git pull" to update your local branch)

nothing to commit, working tree clean
git status  0.40s user 8.55s system 429% cpu 2.082 total
```

We then configure `fsmonitor` and `untrackedcache`:

```
$ git config core.fsmonitor true
$ git config core.untrackedcache true
```

And run twice, to warm up the cache:

```
$ time git status
On branch master
Your branch is behind 'origin/master' by 686 commits, and can be fast-forwarded.
  (use "git pull" to update your local branch)

nothing to commit, working tree clean
git status  0.38s user 1.43s system 159% cpu 1.141 total

$ time git status
On branch master
Your branch is behind 'origin/master' by 686 commits, and can be fast-forwarded.
  (use "git pull" to update your local branch)

nothing to commit, working tree clean
git status  0.13s user 0.03s system 92% cpu 0.178 total
```

The improvement is quite significant. The end performance is under 200 ms, generally considered to be perceived as instantaneous by users. I'm thrilled!

[1]: https://github.blog/2022-06-29-improve-git-monorepo-performance-with-a-file-system-monitor/
