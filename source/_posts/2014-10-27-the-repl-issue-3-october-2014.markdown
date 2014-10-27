---
layout: post
title: "The REPL: Issue 3 - October 2014"
date: 2014-10-27 09:18
comments: true
categories:
- the_repl
---

### [The definitive guide to Arel, the SQL manager for Ruby][1]

Recently I found myself doing pretty interesting things with relational databases that are way, way above what `ActiveRecord` allows you to do (even if I where to condone the use of SQL fragments like `Person.order('YOUR_FIELD DESC')`, which I don't). Arel, which powers `ActiveRecord` is very powerful for that sort of thing, if a little under-documented. The post by Jiří Pospíšil helped out a lot.

### [Move Fast, Breat Nothing][2]

In the post (also a talk), Zach Holman describes how Github continues to innovate and add features to their product, without breaking existing functionality. This post is interesting at the technical level, but also covers how the do team and company structure and communication in a way that doesn't weight them down. Highly recommended.

### [Refactoring From Model to View Helper to Null Object][3]

Short post on using the Null Object Pattern. Polymorphism for the win!


[1]: http://jpospisil.com/2014/06/16/the-definitive-guide-to-arel-the-sql-manager-for-ruby.html
[2]: http://zachholman.com/talk/move-fast-break-nothing/
[3]: http://robots.thoughtbot.com/from-model-logic-to-views-helpers-and-to-null-objects
