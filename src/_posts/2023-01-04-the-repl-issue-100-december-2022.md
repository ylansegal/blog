---
layout: post
title: "The REPL: Issue 100 - December 2022"
date: 2023-02-04 11:21:34 -0800
categories:
- databases
- postgres
- sqlite
- good_job
excerpt_separator: <!-- more -->
---

### [Just Use Postgres for Everything][1]

Systems with less dependencies are less complex. Postgres is amazing, and this article argues to use is as a default for everything. It keeps the number of dependencies low (and accompanying drivers, upgrades, administration tasks, etc). You might now need anything else.
Systems with less dependencies are less complex. Postgres is amazing, and this article argues to use is as a default for everything. It keeps the number of dependencies low (and accompanying drivers, upgrades, administration tasks, etc). You might now need anything else. I can think of a few more reasons to use a single data store: [The Dual-Write Problem](https://thorben-janssen.com/dual-writes/), and [maintaining transactionality](https://brandur.org/job-drain).

### [What is SKIP LOCKED for in PostgreSQL 9.5?][2]

Also from Amazing CTO, this article explains what `SKIP LOCKED` can achieve in Postgres. In particular, the author talks about different ways to implement a job queue in Postgres, and the downsides of different approaches. I'm interested because I've been using [GoodJob](https://github.com/bensheldon/good_job) lately. `SKIP LOCKED` deletes the record first inside a transaction and doesn't need to do anything else if the transaction commits successfully. It's an interesting approach, and probably with better performance than advisory locks. It does require that the job is dequeued in the same transaction as the work being performed. That doesn't seem to be much of a problem.

The objections to advisory locks are:

> Solutions that use advisory locking can work well within limits. Instead of using tuple locks they use [pg\_try\_advisory\_xact\_lock(...)](http://www.postgresql.org/docs/current/static/functions-admin.html) in a loop or using a LIMIT clause to attempt to grab the first unlocked row.

> It works, but it requires that users go way outside the normal SQL programming model.

So does using `SKIP LOCKED`. It is well abstracted in GoodJob. I don't think this argument is very compelling.

> They can’t use their queue table’s normal keys, they have to map them to either a 64-bit integer or two 32-bit integers.

That is abstracted away by GoodJob.

> That namespace is shared across the whole database, it’s not per-table and it can’t be isolated per-application. Multiple apps that all want to use advisory locking on the same DB will tend to upset each other.

True, but GoodJob also takes care of that by generating a string that is good-job specific, calculating the hash, and then converting to a 64 bit integer. Other applications using advisory locks won't conflict.

In summary, I still think that `SKIP LOCKS` would probably have better performance than advisory locks, because it's doing less work updating/deleting each job in the queue, but GoodJob appears to... do a good job.

### [SQLite's automatic indexes][3]

Interesting decision by sqlite: Instead of implementing a hash join, they use a temporary automatic index.
A hash join, if you squint a little is also like creating a temporary index!

[1]: https://www.amazingcto.com/postgres-for-everything/
[2]: https://www.enterprisedb.com/blog/what-skip-locked-postgresql-95
[3]: https://misfra.me/2022/sqlite-automatic-indexes/
