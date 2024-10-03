---
layout: post
title: "The REPL: Issue 121 - September 2024"
date: 2024-10-03 11:45:07 -0700
categories:
- the repl
- postgres
- rails
- security
excerpt_separator: <!-- more -->
---

### [OAuth from First Principles](https://stack-auth.com/blog/oauth-from-first-principles#attack-3)

The articles explains how the problem of sharing access between servers evolves into OAuth, as one starts trying to solve the security issues in the naive implementation.

### [The “email is authentication” pattern](https://rubenerd.com/the-email-is-authentication-pattern/)

For some people, logging into a website means using the "forgot your password" flow every time they want to log in. They do in lieu of other schemes like using the same password, using a password manager, using a password generation scheme, etc.

Are people well informed about the options? From the website's perspective it doesn't matter much: Essentially, having access to an email address grants you access to the website. As long as that is the case, we might as well use "magic links" for authentication and do away with passwords all together.

In fact, in many places, email is now also used as 2-factor authentication. If the website has a "forgot my password" flow via email, then 2-factor via email only adds [the illusion of security][illusion].

### [Solid Queue 1.0 released](https://dev.37signals.com/solid-queue-v1-0/)

I'm happy about this development: Rails should definitely have a canonical queue implementation. I'm also interested in it's performance because  of the `UPDATE FOR SKIP LOCKED` usage. I plan on evaluating it in in the future vs GoodJob. I noticed a few things about the announcement:

37 Signals production setup uses claims 20M jobs per day with 800 workers. That seems like a lot of workers, but without the context of *what* those workers are doing.

They are using a separate database for the queue. While I get that it alleviates some of the performance concerns with the main database, you also loose transactionality between your jobs and the rest of your writes: To me, transactionality is one of the main selling points of using a db-based queueing system. I've chased many production issue where using a separate data store for the jobs ends up causing the queue workers to look for records that are not visible, either temporarily due to a race condition, or permanently because of a roll-back. Using 2 separate databases also means that each Rails process (web or worker) needs a connection to each database.

In the announcement there is a link to a [Postgres-only issue](https://github.com/rails/solid_queue/pull/231) recently fixed, that made me realize that Solid Queue has concurrency controls built-in, and uses `INSERT ON CONFLICT DO NOTHING` to enforce them. That is clever, and more efficient than checking for existence of the concurrency key before inserting.

[illusion]: {% post_url 2014-05-04-the-illusion-of-security %}
