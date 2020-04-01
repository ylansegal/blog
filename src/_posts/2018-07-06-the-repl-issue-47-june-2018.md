---
layout: post
title: "The REPL: Issue 47 - June 2018"
date: 2018-07-06 12:56:16 -0700
comments: true
categories:
- the repl
excerpt_separator: <!-- more -->
---

## [How to GraphQL][1]

GraphQL is an alternative to REST that aims to be more efficient than traditional APIs and allow fast development, both for the server and its clients. This is a fantastic tutorial introduction and hands-on tutorial, with just enough code samples to get a sense of what it is like to write back-end or front-end code in GraphQL. The content is presented in both written and video form. Nice touch.

## [Arel with Wharel][2]

`ActiveRecord`, the ORM that ships with Rails, is an implementation of the ActiveRecord pattern. It's elegant API is one of the things that makes getting started with Rails very convenient. Expressions like `user.posts.where(published: true)` are readable and expressive. When trying to write more complex queries it falls short. In those cases, I usually fall back to `Arel`, the relational algebra library that Rails uses under the hood. While technically, it's considered by the Rails core team to be private API, it's usually very stable. Unfortunately, `Arel` has a more verbose API. [`Wharel`][2] attempts to fix that. Like `Squeel` before it, it adds a bit of syntactic-sugar to make interacting with `Arel` more expressive. It accomplishes this with a minimum amount of code, making it more attractive to use. The author, Chris Salzberg, explains in his [blog post][2] the motivation and code behind the library. I look forward to using it.

## [The impact of the ‘open’ workspace on human collaboration][3]

The findings presented in this paper are that open-office workspaces actually **reduce** the number of face-to-face interactions and increase the number of electronic interactions. The belief that this is not the case has always baffled me. In crowded spaces, like a big-city subway, stadium lines, or elevators, people tend to avoid eye contact, protect the little personal space that they have, and generally keep to themselves. It's a defense mechanism. It's not that people are unfriendly -- it's just that when you clearly don't have any personal space, you don't want to give up your mental space! Clearly, this applies to workspaces as well. If I am sitting with people typing in their keyboard all around me in close proximity, you bet I am going to have headphones on and keep my eyes pointing at my keyboard.

[1]: https://www.howtographql.com/
[2]: https://dejimata.com/2018/5/30/arel-with-wharel
[3]: http://rstb.royalsocietypublishing.org/content/373/1753/20170239
