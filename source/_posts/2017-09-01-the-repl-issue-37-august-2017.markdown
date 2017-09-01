---
layout: post
title: "The REPL: Issue 37 - August 2017"
date: 2017-09-01 08:33:21 -0700
comments: true
categories:
- the_repl
---

### [The fallacies of web application performance][performance]

Is performance only a production concern? Are threads enough for multi-core concurrency? Are there cost-free solutions to solve performance? José Valim answers these en some other questions in this post. José is the creator of Elixir's Phoenix framework and was part of the Rails core team. I've found most of his writing to be worth my time. This is no exception.

### [Developing with Kafka and Rails Applications][kafka]

Sam Goldman explains how Blue Apron uses Ruby on Rails to work with Apache Kafka. Part of the article touches on which gems they use to process Kafka streams. The other portion describes how to setup a local development environment. Docker is leveraged effectively to make a complicated setup something easy to spin up locally: The final product has 4 different services: Zookeper, a Kafka broker, A schema registry, and a REST proxy for Kafka.

### [An Intro to Compilers][compilers]

Nicole Orchard writes an introductory post on how compilers work. Specifically those leveraging the LLVM toolchain -- used by Swift, most Mac `gcc` compilers, Crystal and many more. It takes a simple "Hello, Compiler!" program through the 3 phases: Front-end, Optimizer and Back-end. Short and sweet.

[performance]: http://blog.plataformatec.com.br/2017/07/the-fallacies-of-web-application-performance/
[kafka]: https://bytes.blueapron.com/developing-with-kafka-and-rails-applications-783799e13489
[compilers]: https://nicoleorchard.com/blog/compilers
