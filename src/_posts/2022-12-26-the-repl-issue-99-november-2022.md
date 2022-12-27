---
layout: post
title: "The REPL: Issue 99 - November 2022"
date: 2022-12-26 17:35:53 -0800
categories:
- the repl
- postgres
- rails
excerpt_separator: <!-- more -->
---

### [Postgres: Safely renaming a table with no downtime using updatable views][1]

Once again, Brandur posts a practical example of using Postgres effectively. The article covers how to rename a table safely using views. Other renames can be a bit more complicated, for example in that example, a table was renamed from `chainweel` to `sprocket`. In a typical app, there will also be foreign keys pointing to the table, named `chainweel_id` (or similar). Those would still need to be renamed to `sprocket_id`. Postgres includes support for [generated columns][generated]:

> A generated column is a special column that is always computed from other columns. Thus, it is for columns what a view is for tables.

but it doesn't quite have all the functionality needed to be able to change a column name without down time.

### [Vanilla Rails is plenty][2]

Jorge Manrubia, from 37 Signals, objects to criticism that Rails encourages poor separation of concerns. Among the things that I agree with, is that the use of plain Ruby objects (POROs) is probably underused in most application. I don't like some of the prescriptions in the article, though.

I don't like concerns. While it's nice that functionality is split into it's own file, when included in models they end up making the API of then `ActiveRecord` model bigger. It's already huge to start with. With large code bases, it can be very challenging knowing all the ways that ActiveRecord objects are being used. *Adding* more domain methods doesn't make it better. Instead, I've had better luck using service objects. They make the APIs narrower. A win in my book.

In the last few years, I've found that separating data from functionality is one of the patterns that gives great results and scales well. Value or data objects encapsulate the data. Other classes manipulate that data. Each has it's own lifecycle. Mixing them together is the OOO way -- which Rails leans heavily on -- but it tends to create very broad interfaces (see `ActiveRecord`).

[1]: https://brandur.org/fragments/postgres-table-rename
[generated]: https://www.postgresql.org/docs/12/ddl-generated-columns.html
[2]: https://dev.37signals.com/vanilla-rails-is-plenty
