---
layout: post
title: "The REPL: Issue 79 - March 2021"
date: 2021-04-01 15:52:04 -0700
categories:
- the repl
excerpt_separator: <!-- more -->
---
### [Why OO Sucks][1]
Joe Armstrong, the creator of Erlang, writes why Object-Oriented programming sucks. The main objection is that data and functions should not be bound together:

> Functions are imperative, data is declarative.

I found that resonated with me. I write Ruby every day, but tend to write objects that hold data *only* (e.g. by using `dry-struct`), and other objects that hold logic that operates on data. I started using that time after spending some time writing Elixir, which like Erlang, runs on the BEAM virtual machine.

**PD:** The [link][1] is to the [WayBack Machine][wbm], as the original doesn't seem to be online anymore. It's article not dated, but the earliest crawl is in 2001.

### [Build your own “data lake”][2]

Clément Delafargue explains with lots of detail how his company built a data lake that suits their needs, but avoids the complexity the larger setups may require. It leverages in clever ways Postgres great support for foreign data wrappers. Since their data consumers are all familiar with SQL, using a stable schema as an API to present is a great insight.

### [SQLite is not a toy database][3]

Anton Zhiyanov shows-off a lot of SQLite uses. I typically think of it as a database to use in client applications (e.g. software running on desktops or mobile devices). The examples in the article illustrate how it can be used by for data analysis on a day-to-day basis. SQLite is a great database engine.

[1]: https://web.archive.org/web/20010429235709/http://www.bluetail.com/~joe/vol1/v1_oo.html
[2]: https://tech.fretlink.com/build-your-own-data-lake-for-reporting-purposes/
[3]: https://antonz.org/sqlite-is-not-a-toy-database/
[wbm]: https://web.archive.org/
