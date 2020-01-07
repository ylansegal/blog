---
layout: post
title: "The REPL: Issue 49 - August 2018"
date: 2018-09-06 10:16:26 -0700
comments: true
categories:
- the rep
excerpt_separator: <!-- more -->
---

### [Cost of a Join][1]

Brian Davis writes a detailed post of how expensive it is to do join queries in postgres. The details are very interesting, as is the conclusion: Join operations are usually cheap.


### [Elixir: a few things about GenStage I wish I knew some time ago][2]

I've recently started working on an Elixir project that seems perfectly suited to use [GenStage][genstage]. In this article Andrei Chernykh complements the [GenStage documentation][genstage] and explains how to use it in an approachable manner.

### [What they don’t tell you about event sourcing][3]

Hugo Rocha writes about the pitfalls of using event sourcing. Like most engineering techniques, it is not a perfect fit for every situation. In fact, I believe event sourcing is a sufficiently different paradigm to traditional CRUD applications that it makes it difficult to approach in a iterative manner that other techniques can be incorporated into existing systems.

### [Why JWTs Suck as Session Tokens][4]

Randall Degges writes a good primer on what JWT tokens are, what security guarantees they give, and what problem they are a good solution for. Namely, using them in distributed systems to reduce inter-service calls to verify authentication (or other claims). As the title not-so-subtly suggests, they are not great as session tokens. Most web frameworks already have this problem solved. There is no need to re-invent wheels that are rolling just fine.

[1]: https://www.brianlikespostgres.com/cost-of-a-join.html
[2]: https://medium.com/@andreichernykh/elixir-a-few-things-about-genstage-id-wish-to-knew-some-time-ago-b826ca7d48ba
[3]: https://medium.com/@hugo.oliveira.rocha/what-they-dont-tell-you-about-event-sourcing-6afc23c69e9a
[4]: https://developer.okta.com/blog/2017/08/17/why-jwts-suck-as-session-tokens
[genstage]: https://hexdocs.pm/gen_stage/GenStage.html
