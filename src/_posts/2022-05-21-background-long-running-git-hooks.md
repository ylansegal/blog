---
layout: post
title: "Background long-running git hooks"
date: 2022-05-21 11:20:41 -0700
categories:
- git
- unix
excerpt_separator: <!-- more -->
---

I script that I've been using for years stopped working as expected after I upgraded `bash` and `git`. I use [ctags][ctags] to navigate code in my editor (currently Atom). To automate the generation of the `tags` file, I run the `ctags` executable from git hooks (`post-commit`, `post-merge`, and `post-checkout`), which fits well with my development workflow.

Some of the projects I work with are quite large, and the `ctags` invocation can take longer than 30 seconds. To avoid waiting that long on each commit, I background the invocation. The hook -- that has worked for years -- looked like this:

```shell
#!/usr/bin/env bash
# Regenerate ctags

# Only run one ctags process for this directory at the time.
# Otherwise the ctags file is corrupted
(lockfile .ctags.lock; \
 ctags -R --exclude='*.js' --exclude='*.h' --exclude='*.cpp' &> /dev/null ; \
 rm -f .ctags.lock) &
```

The `lockfile` usage prevents multiple copies of `ctags` running at the same time, which can happen when the hook is invoked often (like when comitting multiple times in quick succession). The `(..)` invoke the commands inside on a sub-shell, and the `&` at the end tells bash to background the work and continue.

I've been using this for years without issue, until I recently upgraded both `git` and `bash` on my machine. The invocation above continued to generate the tags as expected, but instead of backgrounding the work, the git hook would block until `ctags` finished.

I could not find anything related to that in either `git` or `bash` release notes. StackOverflow provided several tips regarding using `nohup` or `disown` but using them didn't help.

Eventually, what did work is redirecting the output of the sub-shell, instead of redirecting the output of `ctags` alone:


```shell
(lockfile .ctags.lock; \
  ctags -R --exclude='*.js' --exclude='*.h' --exclude='*.cpp' ;\
  rm -f .ctags.lock) &> /dev/null &
```

When the sub-shell is instantiated, it's `stdout` and `stderr` are connected to the parent process (i.e. the git hook). My best guess is that after the upgrade, the hook invocation now waited until the sub-shell existed because it's `std{out,err}` was connected to the sub-shell's. With the new invocation, the `(..) &> /dev/null` disconnects the output streams for the whole sub-shell from the hook's output streams, by redirecting it to `/dev/null`. The hook's process can then safely close its own `std{out,errr}` and exit.


[ctags]: https://ctags.io/
