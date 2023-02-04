---
layout: post
title: "The Bike Shed Podcast Feedback"
date: 2021-10-20 09:23:52 -0700
categories:
- databases
- good_job
excerpt_separator: <!-- more -->
---

I recently listened to the [The Bikshed, Episode 313](https://www.bikeshed.fm/313) and sent some feedback for the hosts:

---

Hello Chris & Steph! I am a long-time listener of the podcast. Thank you for taking the time each week to record it.

On [The Bikshed, Episode 313](https://www.bikeshed.fm/313) you discussed a failure mode in which a Sidekiq job is enqueued inside a transaction. The job gets processed _before_ the transaction commits, so the job encounters an unexpected database state. The job eventually succeeds when retried after the transaction commits.

The proposed solution, is to enqueue the job after the transaction commits. This certainly fixes that particular failure mode. It also makes possible different ones. Imagine the transaction commits, but the Sidekiq job can not be enqueued for whatever reason (e.g. network partition, buggy code, server node's process runs out of memory). In this instance, you will fail to process your order. Is this better? You might not even notice that no job was enqueued. You can add code to check for that condition, of course.

In the original configuration, there are other failure modes as well. For example, the write to the database succeeds, the job enqueues, but then the transaction fails to commit (for whatever reason). Then you have a job that won't succeed on retries. To analyze all failure modes, you need to assume that any leg of the network communication can fail.

The main problem you are running up against is that you trying to write to two databases (Postgres and Redis) in a single _conceptual_ transaction. This is known as the "Dual Write" problem. Welcome to distributed systems. You can read a more thorough explanation by [Thorben Janssen](https://thorben-janssen.com/dual-writes/).

The approach outlined in that article -- embracing async communication -- is one way to solve the issue. For smaller Rails apps, there is another approach: Don't use two databases! If you use a Postgres-based queue like [GoodJob](https://github.com/bensheldon/good_job) or even [DelayedJob](https://github.com/collectiveidea/delayed_job/) you don't have this problem: Enqueuing the job is transactional, meaning that either everything writes (the records and the job) or nothing does: That is a very powerful guarantee. I try to hold on to it as much as possible.

I hope you've found this helpful.

Thanks again for the podcast.
