---
layout: post
title: "Surprise in Arel's API"
date: 2023-06-19 09:58:03 -0700
categories:
- rails
- arel
excerpt_separator: <!-- more -->
---

`arel` -- A relational algebra library -- is the ruby library that that powers `ActiveRecord`. It provides a lower-level abstraction for working with `SQL` than `ActiveRecord`, and typically used when a particular query is *not* possible with `ActiveRecord`. Over the years, I've reached out for it on occasion. [The definitive guide to Arel, the SQL manager for Ruby][1] provides good information if you haven't used it before.

I was recently working with a complicated query, and spent way more time because I assumed some things about it's API that turned out to not be true.

Let's first observe how `ActiveRecord::Relations` behave:


```ruby
ar_relation = User.where.not(active_thru: nil)
ar_relation.to_sql
# =>  SELECT "users".* FROM "users" WHERE "users"."active_thru" IS NOT NULL

ar_relation.where(id: 5).to_sql
# => SELECT "users".* FROM "users" WHERE "users"."active_thru" IS NOT NULL AND "users"."id" = 5

ar_relation.to_sql
# SELECT "users".* FROM "users" WHERE "users"."active_thru" IS NOT NULL
```

Notice how calling a second `where` on a relation returns a *new* relations without modifying the original. This allows composing relations in Rails with great effect.

However, that is not true with `Arel::SelectManager` classes:

```ruby
table = User.arel_table
arel_manager = table.where(table[:active_thru].not_eq(nil))
arel_manager.to_sql
# => SELECT FROM "users" WHERE "users"."active_thru" IS NOT NULL

arel_manager.where(table[:id].eq(5)).to_sql
# => SELECT FROM "users" WHERE "users"."active_thru" IS NOT NULL AND "users"."id" = 5

arel_manager.to_sql
# => SELECT FROM "users" WHERE "users"."active_thru" IS NOT NULL AND "users"."id" = 5
```

Notice how adding a new `where` clause modified the original object.

*Caveat Emptor*


[1]: https://jpospisil.com/2014/06/16/the-definitive-guide-to-arel-the-sql-manager-for-ruby
