---
layout: post
title: "The REPL: Issue 97 - September 2022"
date: 2022-10-03 15:54:29 -0700
categories:
- the repl
- git
- postgres
- elixir
excerpt_separator: <!-- more -->
---

### [Signing Git Commits with Your SSH Key][1]

SSH keys are more common than GPG keys, by far. I don't know many developers that have GPG keys, but all of them have SSH keys, if only to use GitHub. However, the support for the signatures seems a bit rough at the moment.

### [Transactionally Staged Job Drains in Postgres][2]

The article explains well how background jobs that run *outside* of a db transaction can have several categories or problems. However, job queues driven by relational databases sometimes don't scale well, when compared to other queues. For example see `DelayedJob`, or `Que` vs `Sidekiq`. The article presents a pattern that keeps the transactionality, but regains much of the performance by using a staging table for jobs, which drains into the actual job queue that will do the work.

### [Understanding GenStage back-pressure mechanism][3]

Really concise explanation of what the concept of **back-pressure** means in Elixir, and how it can prevent overflow and the capacity of the system being exceeded.

[1]: https://calebhearth.com/sign-git-with-ssh
[2]: https://brandur.org/job-drain
[3]: https://dev.to/dcdourado/understanding-genstage-back-pressure-mechanism-1b0i?utm_medium=email&utm_source=elixir-r
