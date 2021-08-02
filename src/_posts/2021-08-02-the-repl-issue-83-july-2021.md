---
layout: post
title: "The REPL: Issue 83 - July 2021"
date: 2021-08-02 15:02:18 -0700
categories:
- the repl
excerpt_separator: <!-- more -->
---

### [GoodJob](https://github.com/bensheldon/good_job)

I recently found `GoodJob`, a background-job library for Ruby. It's compatible with `ActiveJob`. Its main selling points is that it takes advantage of Postgres features. For projects already on Postgres this means two things: There is no need for another data store, and job scheduling can be transactional with the rest of the application.

Sidekiq, the [leading](https://www.ruby-toolbox.com/categories/Background_Jobs) background job library requires the use of Redis. It scales exceptionally well. For many applications managing another data store in production is burdensome, and provides little tangible benefits, especially if the load on the database is low. GoodJob even has a mode that runs the workers in the same process as the Rails server. For smaller apps running on Heroku, this can remove the need of a separate dyno.

Regarding the transactional nature: Suppose you want to store a record and queue a background job as part of some business operation. If you write to your main database first you run the risk of failing when enqueuing the job. Enqueuing inside a transaction doesn't work either. In case of a transaction rollback, the job will still be published, like [Brandur explains](https://brandur.org/http-transactions#background-jobs). Keeping jobs in the same database as the rest of the data, allows for transactional semantics -- much easier to code against.

I've only tried this library on a side project with little traffic, but so far I am very impressed.

### [Idempotency-Key IETF Standards Draft](https://brandur.org/fragments/idempotency-key-draft)

Speaking of Brandur: He notes that the IETF has a new draft standard for an `Idempotency-Key`, already in use at Stripe and other places. He [previously](https://brandur.org/http-transactions) explains in more detail why it's important.
