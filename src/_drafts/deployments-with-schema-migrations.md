---
TODO:
  - add date
  - Diagrams
  - Finish content
  - excerpt
layout: post
title: "Deployments With Schema Migrations"
categories:
- deployment
- rails
---

The typical web application runs application processes separately from its database process. More often than not, in different servers altogether. As applications evolve, it is common for new features to require changes in the database schema that the code relies on. In Ruby on Rails, these schema changes are handled through _migrations_: Ruby classes that implement a DSL for specifying how to change the database from an initial state, to its target state. They also contain information on how to roll-back the migration, in case a deployment needs to be undone.

A lot of web frameworks provide similar features. In the rest of the post I will talk specifically about Ruby on Rails, the one I am most familiar with. I expect that the lessons carry over beyond it.

# A New Feature

For the sake of an example, let us assume we are building a blog. Our database has a `posts` table that holds a single post on each row. Our blog as been so successful, that our product team wants us to implement a commenting system, in which each post has many comments.

We start with our initial code (`V0`), and an initial database state (`S0`):

```ruby
# V0
class Post < ActiveRecord::Base
end
```

```ruby
# db/schema.rb - S0
create_table "posts", force: :cascade do |t|
  t.text "title"
  t.text "body"
  t.datetime "created_at", precision: 6, null: false
  t.datetime "updated_at", precision: 6, null: false
end
```

After our code changes, our code (`V1`) and schema state (`S1`) will have changed to:

```ruby
# V1
class Post > ActiveRecord::Base
  has_many :comments
end

class Comment < ActiveRecord::Base
  belongs_to :post
end
```

```ruby
# db/migrate/20200103001823_create_comments.rb
class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.references :post, null: false, foreign_key: true
      t.text :body
      t.timestamps
    end
  end
end
```

```ruby
# db/schema.rb - S1
create_table "posts", force: :cascade do |t|
  t.text "title"
  t.text "body"
  t.datetime "created_at", precision: 6, null: false
  t.datetime "updated_at", precision: 6, null: false
end

create_table "comments", force: :cascade do |t|
  t.bigint "post_id", null: false
  t.text "body"
  t.datetime "created_at", precision: 6, null: false
  t.datetime "updated_at", precision: 6, null: false
  t.index ["post_id"], name: "index_comments_on_post_id"
end

add_foreign_key "comments", "posts"
```

The `db/schema.rb` are provided for reference: They are typically not be used in production, as the database will be evolved by running `rails db:migrate` which will run any pending migrations in order.

# Downtime Deployment

Conceptually, the simplest deployment is one were our web app incurs some downtime. In this scenario, the sequence of operations is as follows:

1. Redirect all traffic to a maintenance page.
2. Stop our processes running `V0`
3. Install the new version of the code `V1`
4. Run database migrations, changing the database schema from `S0` to `S1`.
5. Boot `V1` processes
6. Restore traffic to the web application.

<img src="/assets/images/diagrams/downtime_migration.png" alt="Downtime Deployment" class="center">

As the diagram illustrates, `V0` always runs with schema `S0`, and `V1` always runs with `S1`. This state of affairs stable, but not always desirables. Business usually aim to minimize downtime. The current trend in continuous deployments is to deploy small increments of code multiple times a day. Taking downtime on each deployment is unacceptable.

# The Simplest Non-Downtime Deployment

The simplest non-downtime deployment I can imagine is an instantaneous one. Our server is running `V0`. An instance later, the code swapped and the server is running `V1`. Cleary, this type of deployment does not exist, but please follow along for the thought exercise.

In this scenario, when do we run our migration? Before or after the code is swapped?

Since we have been writing tests all along to develop our features, we are confident that `V0` is compatible with `S0`, and `V1` is compatible with `S1`.

Our `S1` code clearly relies on the `comments` table existing in the database. If the code boots and the table is missing, we will get exceptions similar to:

```ruby
post.comments
# => ActiveRecord::StatementInvalid (PG::UndefinedTable: ERROR:  relation "comments" does not exist)
```

In development and test environments, Rails does it best to be helpful and will let you know that migrations are pending, so that you don't encounter this problem. In production mode, however this will not be the case.

Our `V0` code on the other hand only relies on `S0` being present. As defined, `S1` is purely additive -- meaning new things are added, nothing removed, nothing changed. The implication is that `V0` code is compatible with `S0` *and* `S1`. We can test this combination by creating a branch that has the `V0` code, and the `S1` migrations, but does not include any of the `V1` changes. If all the tests pass against this configuration, it gives us confidence that this is a compatible state. This branch does not need to be deployed, it serves only as a canary.

We can tabulate the above in a compatibility matrix:

| Code Version | DB Schema | Compatible? |
|:------------:|:---------:|:-----------:|
|     `V0`     |   `S0`    |     Yes     |
|     `V0`     |   `S1`    |     Yes     |
|     `V1`     |   `S0`    |     No      |
|     `V1`     |   `S1`    |     Yes     |

Given the above, we can deduce that during our deployment, the migrations need to run *before* the code-swap phase.

![Instantaneous deployment, with migration](TBD)

In case that a rollback is needed we would be in a position in which `V1` is running on an `S1` schema. It continues to be true that `V1` is only compatible with `S1`. The implication is that the migration rollback needs to occur *after* the code-swap. If at all. Depending on what went wrong, sometimes a code swap without the database migration is enough to address issues.

# A More Accurate Model of Deployment
