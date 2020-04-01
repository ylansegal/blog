---
layout: post
title: "The REPL: Issue 12 - July 2015"
date: 2015-07-31 08:55:43 -0700
comments: true
categories:
- the repl
excerpt_separator: <!-- more -->
---

### [Elixir in times of microservices][1]

José Valim, creator of Elixir and Rails Core member, weighs in on microservices. He makes a great case on why Elixir, leveraging the Erlang VM makes it easier to work with distributed systems and imposes less up-front tradeoffs than the  current trend of microservices communicating via JSON API.

### [Elegant APIs with JSON Schema][2]

At work, I have been exploring how to work effectively with microservices on a Rails stack. JSON Schema, comes up often, especially, especially with all the tools open-sourced by [Heroku/Interagent][4]. The [blog post][2] by @brandur, is the best introduction to JSON Schema I have read so far.

### [Improved production stability with circuit breakers][3]

The circuit breaker pattern provides a way for resiliency and stability when working with distributed systems. In this post, Heroku introduces their new Ruby library for implementing the pattern. I especially liked the idea of having a roll-out strategy introducing logging-only circuit breakers first. At the very end, they advise to tune timeout settings for underlying libraries. Don't know how to do that? Check the [Ultimate Guide To Timeouts In Ruby][5]


[1]: http://blog.plataformatec.com.br/2015/06/elixir-in-times-of-microservices/
[2]: https://brandur.org/elegant-apis
[3]: https://engineering.heroku.com/blogs/2015-06-30-improved-production-stability-with-circuit-breakers/
[4]: https://github.com/interagent/
[5]: https://github.com/ankane/the-ultimate-guide-to-timeouts-in-ruby?utm_source=rubyweekly&utm_medium=email#nethttp
