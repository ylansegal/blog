---
layout: post
title: "A Rails Migration Foot Gun"
date: 2024-11-16 11:37:06 -0800
categories:
- rails
excerpt_separator: <!-- more -->
---

I recently discovered a [foot gun](https://en.wiktionary.org/wiki/footgun) when writing rails migrations.

Rails runs migrations inside a transaction by default, for those databases that support it (e.g. Postgres). It also provides a what to disable it if you so choose, by using `disable_ddl_transaction!`. That can be useful for example for creating a large index concurrently, which is not supported inside a transaction. It looks like this:


```ruby
class FootGun < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    create_table :foot_guns
  end
end
```

So far, so good. However, because of how `disable_ddl_transaction!` is implemented, there is also a `disable_ddl_transaction` method defined. That is an accessor that checks weather the migration should be run in a transaction or not. But it can be used by mistake:

```ruby
class FootGun < ActiveRecord::Migration[7.2]
  disable_ddl_transaction # This doesn't do anything!!!

  def change
    create_table :foot_guns
  end
end
```

The migrations **looks** like it is disabling the transaction, but it's actually not. It' also a hard mistake to catch, because the output rails prints out when running the migration in both cases is the same:

```
$ rails db:migrate
== 20241116193728 FootGun: migrating ==========================================
-- create_table(:foot_guns)
   -> 0.0137s
== 20241116193728 FootGun: migrated (0.0158s) =================================
```

I'd love for `disable_ddl_transaction` not to exist at all, so that a `NameError` would be raised, and this mistake was impossible to make.
