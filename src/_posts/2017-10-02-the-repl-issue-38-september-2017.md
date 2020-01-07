---
layout: post
title: "The REPL: Issue 38 - September 2017"
date: 2017-10-02 08:41:01 -0700
comments: true
categories:
- the rep
excerpt_separator: <!-- more -->
---

### [Developing with Kafka and Rails Applications][ruby_kafka]

In this article, Sam Goldman gives an overview of how Blue Apron uses the `ruby-kafka` gem to produce and consume Kafka topics from Ruby. In addition, he shows how to leverage docker and docker compose to create a local development environment, which would otherwise be relatively complex since it needs 4 different supporting services (zookeper, Kafka broker, a schema registry and a REST proxy).

### [Introduction to Concurrency Models with Ruby][concurrency_1]

This post ([part 1][concurrency_1]) and it's follow-up ([part 2][concurrency_2]) explain the different ways to work with concurrency in Ruby. It covers Processes, Threads, the GIL, Fibers and more abstract models like Actors, Sequential Processes, Software Transactional Memory and the new proposal for concurrency in Ruby: Guilds.

### [Using Atomic Transactions to Power an Idempotent API][atomic]

@brandur writes a detailed post on how to treat HTTP API requests as transactions and build them in a way that they are idempotent -- they can be called multiple times, without affecting the result. The author does a great job of covering the database, MVC framework code and even how to work with background processes. The diagrams illustrate elegantly how race conditions can occur and how to mitigate them.

[ruby_kafka]: https://blog.blueapron.io/developing-with-kafka-and-rails-applications-783799e13489
[concurrency_1]: https://engineering.universe.com/introduction-to-concurrency-models-with-ruby-part-i-550d0dbb970
[concurrency_2]: https://engineering.universe.com/introduction-to-concurrency-models-with-ruby-part-ii-c39c7e612bed
[atomic]: https://brandur.org/http-transactions
