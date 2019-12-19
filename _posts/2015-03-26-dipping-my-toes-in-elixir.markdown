---
layout: post
title: "Dipping my toes in Elixir"
date: 2015-03-26 08:55:12 -0700
comments: true
categories:
- elixir
---

I recently came across two interesting posts about the [Phoenix framework][1]: A [benchmark][2] comparing the performance against Rails and a how-to for creating a [simple JSON API][3]. I was interested by the performance characteristics described in both articles. What really got my attention though was the syntax: The feel for it was very ruby-like.

Phoenix is written in [Elixir][4], a relatively young functional programming language design by Jose Valim, committer in the Rails Core team. Elixir compiles to byte-code that runs on the Erlang virtual machine, which lists as it's main features scalability and fault-tolerance.

The main Elixir website has the best [getting started guide][5] I have ever read. I started off by installing Elixir, which on my Mac was as simple as `$ brew install elixir`. That took care of the Erlang VM and whatever else it needed. A few moments later I had a working elixir installation, ready to go.

The guide is written in clear and concise manner, introducing the reader to the language, the syntax, the tools and the concepts in a gradual manner. I am not familiar with functional programming, other than what I have heard described in a few podcast. Even so, I was able to follow along quickly and start exploring. The guide also includes a more advanced section covering `mix` and OTP.

`mix` is the main tool that Elixir uses for compiling code, resolving and getting dependencies, running tests, etc. Think of it as the equivalent of `make` or `rake`. OTP stands for "Open Telecom Platform" and is a set of libraries included with Erlang that allows developers to build fault-tolerant, distributed applications.

`mix` is a pleasure to work with: Be it creating a new project, installing dependencies or running your test, you go through `mix`. (As opposed to `rails`, `rake`, `bundler`)


`ExUnit`, the included testing framework is familiar to anyone having used any XUnit framework before. The error messages are helpful by default. It includes a great feature where examples inside the documentation of a module can be executed as tests directly. I was very happy to see that the guide introduces tests and TDD early on. It shows the values of the Elixir community, load and clear.

Concurrency is prominent. In fact, in order to have any kind of state at all, you need to use separate Elixir `Process`es, which are like light-weight threads, not system processes. Messages are sent between processes. I like the idea of having to think about concurrency early, as opposed than doing later in the application life-cycle. Elixir processes are allowed to fail fast on errors. It's not a big deal, since they are under `Supervisor`s that will just restart them if they fail.

Pattern-matching at first seems weird. They grow on you. It allows the programmer to deal with different cases easily and separate them out into their own functions, foregoing a lot of conditionals. Defining functions many times, with different guard clauses is great. It's hard to describe (because I don't know the correct language yet), but here is my take on the Fibonacci sequence:

``` elixir
defmodule F do
  def fib(x) when x in 1..2  do
    1
  end

  def fib(x) do
    fib(x - 2) + fib(x - 1)
  end
end

IO.puts F.fib(5)
```

In conclusion: I have barely gotten my feet wet, but have been impressed with what I have seen. I was not expecting this level of polish from a new language. I am itching to find a personal project to write in Elixir!

[1]: http://www.phoenixframework.org/
[2]: http://www.littlelines.com/blog/2014/07/08/elixir-vs-ruby-showdown-phoenix-vs-rails/
[3]: https://robots.thoughtbot.com/testing-a-phoenix-elixir-json-api
[4]: http://elixir-lang.org/
[5]: http://elixir-lang.org/getting-started/introduction.html
