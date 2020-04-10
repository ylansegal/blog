---
layout: post
title: "The REPL: Issue 66 - February 2020"
date: 2020-04-09 19:06:12 -0700
categories:
- the repl
excerpt_separator: <!-- more -->
---

### [How to break a Monolith into Microservices][fowler]

Like so much of the content in Martin Fowler's website, this article -- by Zhamak Dehghani -- is a well-though out description of how to reason breaking out a monolith into services. Some choice quotes:

> Every increment must leave us in a better place in terms of the architecture goal.

In the context of leaving both the old way and the new way in place:

> If the team stops here and pivots into building some other service or feature, they leave the overall architecture in a state of increased entropy.
> At this point the teams are actually further away from their overall goal of making changes faster. Any new developer to the monolith code needs to deal with two code paths, increased cognitive load of understanding the code, and slower process of changing and testing it.

It's well worth the read.

### [Ready for changes with Hexagonal Architecture][netflix]

Many of the blog post written by large engineering organizations, don't often apply to smaller organizations. While they are still interesting, reading how Google and Amazon handle load doesn't necessarily translate into practical advice. This post by Damir Svrtan and Sergii Makagon in the Netflix Engineering Blog is different. They describe how they went about building a new service rapidly, meant to integrate with a variety with other services, even in the face of unknown requirements. Their solution: Hexagonal Architecture.

> The idea of Hexagonal Architecture is to put inputs and outputs at the edges of our design. Business logic should not depend on whether we expose a REST or a GraphQL API, and it should not depend on where we get data from — a database, a microservice API exposed via gRPC or REST, or just a simple CSV file.

In particular, they way they defined their core concepts resonated with me. They stuck most of their code into *Entities* (domain objects), *Repositories* (read and write data), and *Interactors* (orchestration classes -- i.e. service classes, use case objects).

### [Services By Lifecycle][lifecycle]

I've been doing a lot of research into multi-service architectures, and I've seen many references to how entity services are an anti-pattern. Michael Nygard has a [previous article][entity_service] describing just that. Designing services to _avoid_ the anti-pattern is sometimes easier said than done. This post walks the reader on how to avoid the pitfalls with a concrete example modeling services based on the business lifecycle, instead of just focusing on the data that they store.

[fowler]: https://martinfowler.com/articles/break-monolith-into-microservices.html#MigrateInAtomicEvolutionaryStepso
[netflix]: https://netflixtechblog.com/ready-for-changes-with-hexagonal-architecture-b315ec967749
[lifecycle]: https://www.michaelnygard.com/blog/2018/01/services-by-lifecycle/
[entity_service]: https://www.michaelnygard.com/blog/2017/12/the-entity-service-antipattern/
