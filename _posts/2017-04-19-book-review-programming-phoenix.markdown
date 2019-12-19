---
layout: post
title: "Book Review: Programming Phoenix"
date: 2017-04-19 08:54:54 -0700
comments: true
categories:
- books
- elixir
---

*Programming Phoenix: Productive -> Reliable -> Fast* by Chris McCord, Bruce Tate, José Valim is an introduction to Phoenix, a web application framework written in Elixir. The authors bring a lot to the table: Chris is the main author and manitainer of Phoenix. José is the author of Elixir, prolific contributor to Phoenix and once a Rails core member. Bruce is author on several books about Java and Rails.

The book walks through building a complete web-application with Phoenix from scratch, covering it's particular take on MVC, testing, database access and web-sockets. The book itself is written in clear language and can be easily followed by beginners and advanced programmers alike. Along the way, it explains not only _how_ to use the framework, but _why_ it was designed to work that way in the first place -- usually to address a shortcoming that the author's perceived in other web frameworks. The explanations in the book are thorough, without being repetitive. Meticulous, without being pedantic or condescending. It's a great example of what technical writing should be.

In a lot of ways Phoenix feels very similar to Rails. The places where it differs matter. In general, it prefers being more explicit and less magic-like. The different parts of the framework, like the router, controllers, models and views are less coupled to each other than Rails, but still fit together nicely. In practice, this means that following the "Elixir Way" is as easy as following the "Rails Way", but it makes it much easier to test functionality and hook into the framework when needed.

One of the places where Phoenix really shines is Channels. Channels allow a near real-time connection between the server and it's client, outside of the regular request/response cycle. Channels typically will use web-sockets, but can fall back to long-polling. The abstractions exposed make it easy to reason about how data flows from and to clients. They are also very efficient and use few server resources, due to Elixir underpinnings in the Erlang VM.

Elixir in general, and Phoenix in particular, have great tooling. `mix` is usually the entry-point from the command line to dependency management, running tests, starting processes, etc. For Rubyists, it's like `gem`, `bundle`, `rake` and `rails` rolled into one well-rounded tool.

Although Elixir and Phoenix are relatively new, they have reached a high level of maturity by building on tried and tested technology. This book will get you up to speed on writting Phoenix applications fast.
