---
layout: post
title: "The REPL: Issue 42 - January 2018"
date: 2018-02-07 08:24:20 -0800
comments: true
categories:
- the repl
---

### [SPAs Are Just Harder, And Always Will Be][spa]

William Gross points out that [Single-Page Applications][spa_def] add more development overhead than traditional server-rendered applications. There are more layers to code and maintain and essentially add to each browser the burden of distributed computation and data synchronization.

### [Things I wish ActiveRecord had after using Ecto][ecto]

[Ecto][elixir-ecto] is a database wrapper library for Elixir. It's design is very different that [ActiveRecord][active_record] -- the Ruby library included with Ruby on Rails. They are often compared, because each seems to hold the majority of mindshare in it's own ecosystem and there is a significant portion of the Ruby community interested in Elixir.

Vladimir Rosančić walks through the things he likes about Ecto that are missing from ActiveRecord. He names changesets, database constrain validation, explicit pre-loading, batch inserts, safety when loading single records and the query language itself. I find these type of comparisons really useful. They usually make clear how the choice of language or library affects the code we write.

### [The Modular Monolith: Rails Architecture][monolith]

In this post Dan Manges details how the engineering team at Root dealt with the fabled Rails monolith and made it more modular. The achieved a healthier separation of concerns, faster builds and got rid of circular dependencies by using Rails Engines to separate the different domains in their app. They obtained a lot of the benefits often attributed to micro-services, without adding layers of network traffic (and the failure modes that come with that) in the middle of their app.

[spa]: http://wgross.net/essays/spas-are-harder
[spa_def]: https://www.codeschool.com/beginners-guide-to-web-development/single-page-applications
[ecto]: https://infinum.co/the-capsized-eight/things-i-wish-active-record-had-after-using-ecto
[elixir-ecto]: https://github.com/elixir-ecto/ecto
[active_record]: http://guides.rubyonrails.org/active_record_basics.html
[monolith]: https://medium.com/@dan_manges/the-modular-monolith-rails-architecture-fb1023826fc4
