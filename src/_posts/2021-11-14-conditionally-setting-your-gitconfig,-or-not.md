---
layout: post
title: "Conditionally setting your gitconfig, or not"
date: 2021-11-14 12:23:24 -0800
categories:
- git
excerpt_separator: <!-- more -->
---

In [Conditionally setting your gitconfig](https://utf9k.net/blog/conditional-gitconfig/), Marcus Crane solves a problem that many of us have: Different `git` configuration for personal and work projects. His solution includes adding _conditional_ configuration, like so:

```
[includeIf "gitdir:~/work/"]
  path = ~/.work.gitconfig
```

I've been taking a different approach. According to the [git-scm configuration page](https://www.git-scm.com/book/en/v2/Customizing-Git-Git-Configuration), `git` looks for system configuration first, the the user's personal configuration (`~/.gitconfig` or `~/.config/git/config`), and then the project's specific configuration.

In my personal configuration, I typically set my name, but don't set my email.

```
[user]
  name = Ylan Segal
```

On first interaction with a repository, `git` makes it evident that an email is needed:

```
$ git commit
Author identity unknown

*** Please tell me who you are.

Run

  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"

to set your account's default identity.
Omit --global to set the identity only in this repository.

fatal: no email was given and auto-detection is disabled
```

I then use `git config user.email "ylan@...."` to set a project-specific email. I **don't** use the `--global` option. I want to make that choice each time I start interacting with a new repo.

As they say, there are many ways to skin a cat.
