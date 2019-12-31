---
layout: post
title: "Book Review: Functional Web Development with Elixir"
date: 2018-02-26 14:22:37 -0800
comments: true
categories:
- books
- elixir
---

*Functional Web Development with Elixir, OTP, and Phoenix: Rethink the Modern Web App* by Lance Halvorsen covers how to build web application in Elixir leveraging it's great concurrency properties using OTP. Throughout the book, the author guides the reader through building an application. At first, the focus is only on the business logic, outside from any web-framework. Later, the author covers how to use that code inside a Phoenix application without the tight coupling that often results in other web frameworks. Phoenix web views are largely ignored, focusing instead on it's finest features: Channels and Presence.

Considerably time is spent discussing OTP and GenServers in particular. I feel I have a relatively good understanding, while at the same time feeling that something hasn't quite "sunk in" yet. It was also great to learn the basics of supervision trees, ETS (the in-memory storage built-in to the BEAM), and MNESIA (a relational database that is also built-in that doesn't use SQL).

The app is built chapter by chapter, in a bottom-up approach. While the reader does end up with a functioning application, it is easy to miss the forest for the trees. Especially, since most readers won't have OTP experience and don't know how those applications are structured. I would have much rather have seen an outside-in approach, especially one driven by tests.

I was also disappointed that testing was not even mentioned in the book. I consider testing to be an integral part of my day-to-day work and can't really evaluate a framework or language without knowing what the ergonomics of testing are like. In particular I am left wondering how to test asynchronous code, channels or presence modules, especially when it requires passing `Socket` structures to functions.

In my other explorations of Elixir, I've read about umbrella applications being a great way to keep modules separate. While the author spends considerable time on the same subject, he doesn't mention umbrella applications (either negatively or positively).

Finally, while I enjoyed the book, I did find that there seems to be some implicit assumption that Elixir scales very well across nodes, but I wish there was more of an explanation of how computation is distributed among Elixir/Erlang nodes and in particular how is state propagated between them when using something like ETS.

Links:

- [The Pragmatic Bookshelf](https://pragprog.com/book/lhelph/functional-web-development-with-elixir-otp-and-phoenix)
