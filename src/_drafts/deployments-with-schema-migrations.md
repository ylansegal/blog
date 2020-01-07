---
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

<img src="/assets/images/diagrams/downtime_deployment.png" alt="Downtime Deployment" class="center">

As the diagram illustrates, `V0` always runs with schema `S0`, and `V1` always runs with `S1`. The migration `S0 -> S1` runs during the dowtime.

## Rollback

In case we need to rollback the deployment, we would do so by doing the inverse deployment. The migration would run in a "down" migration durning the downtime:

<img src="/assets/images/diagrams/downtime_rollback.png" alt="Downtime Rollback" class="center">

Note that since the code for the migration -- the instructions to convert `S0` to `S1` and viceversa -- exists only in the `S1` code. This needs to be taken into account when swapping code during the deployment process.

Deploying and rolling back with downtime is stable, but not always desirable. Businesses usually aim to minimize downtime. The current trend in continuous deployments is to deploy small increments of code multiple times a day. Taking downtime on each deployment is unacceptable.

# The Simplest Non-Downtime Deployment

The simplest non-downtime deployment I can imagine is an instantaneous one. Our server is running `V0`. An instance later, the code swapped and the server is running `V1`. Cleary, this type of deployment does not exist, but please follow along for the thought exercise.

In this scenario, when do we run our migration? Before or after the code is swapped?

Since we have been writing tests all along to develop our features, we are confident that `V0` is compatible with `S0`, and `V1` is compatible with `S1`. The other possible configuration are `V1`-`S0` and `V0`-`S1`.

Our `S1` code clearly relies on the `comments` table existing in the database (`S1`). If the code boots and the table is missing, we will get exceptions similar to:

```ruby
post.comments
# => ActiveRecord::StatementInvalid (PG::UndefinedTable: ERROR:  relation "comments" does not exist)
```

In development and test environments, Rails does it best to be helpful and will let you know that migrations are pending, so that you don't encounter this problem. In production mode, however this will not be the case. The rails tooling makes it hard to test this configuration.

As defined, `S1` is purely additive -- meaning new things are added, nothing removed, nothing changed. The implication is that `V0` code is compatible with `S0` *and* `S1`. We can test this combination by creating a branch that has the `V0` code, and the `S1` migrations, but does not include any of the `V1` changes. If all the tests pass against this configuration, it gives us confidence that this is a compatible state. This branch does not need to be deployed, it serves only as a canary.

We can tabulate the above in a compatibility matrix:

| Code Version | DB Schema | Compatible? |
|:------------:|:---------:|:-----------:|
|     `V0`     |   `S0`    |     Yes     |
|     `V0`     |   `S1`    |     Yes     |
|     `V1`     |   `S0`    |     No      |
|     `V1`     |   `S1`    |     Yes     |

Given the above, we can deduce that during our deployment, the migrations need to run *before* the code-swap phase.

<img src="/assets/images/diagrams/instant_deployment.png" alt="Instantaneous Deployment" class="center">

In case that a rollback is needed we would be in a position in which `V1` is running on an `S1` schema. It continues to be true that `V1` is only compatible with `S1`. The implication is that the migration rollback needs to occur *after* the code-swap. If at all. Depending on what went wrong, sometimes a code swap without the database migration is enough to address issues.

<img src="/assets/images/diagrams/instant_rollback.png" alt="Instantaneous Rollack" class="center">

So far, we've determine on which side of the code swap our migration needs to run. In the diagram the migration is labeled as `S0 -> S1`, and is show as taking a certain amount of time. During this period, we can't be sure in which state (`S0` or `S1`) our database is in, but we know that `V0` is compatible either way. Do we have to worry about an state in-between `S0` and `S1`? It depends. The [Rails documentation](https://guides.rubyonrails.org/active_record_migrations.html#migration-overview) states:

> On databases that support transactions with statements that change the schema, migrations are wrapped in a transaction. If the database does not support this then when a migration fails the parts of it that succeeded will not be rolled back. You will have to rollback the changes that were made by hand.

If you are using Postgres, transaction support ensures that you are in either `S0` or `S1`. For other databases, like MySQL, this might not be true for all migrations. In our example, the migration produces one -- and only one -- data definition statement. It will either succeed or fail. Even if transactions are not supported, we probably don't need to worry. For the purpose of the rest of the post, I will assume then that we can be sure that our database is either in `S0` or `S1`, and that `SO -> S1` implies that we could be in either state.

# A More Accurate Model of Deployment



Heroku deployment log:
```
2020-01-06T23:48:28.253359+00:00 app[api]: Deploy 6909d7c6 by user ylan@...
2020-01-06T23:48:28.660547+00:00 app[api]: Starting process with command `/bin/sh -c 'if curl $HEROKU_RELEASE_LOG_STREAM --silent --connect-timeout 10 --retry 3 --retry-delay 1 >/tmp/log-stream; then
2020-01-06T23:48:28.660547+00:00 app[api]: chmod u+x /tmp/log-stream
2020-01-06T23:48:28.660547+00:00 app[api]: /tmp/log-stream /bin/sh -c '"'"'bundle exec rake db:migrate'"'"'
2020-01-06T23:48:28.660547+00:00 app[api]: else
2020-01-06T23:48:28.660547+00:00 app[api]: bundle exec rake db:migrate
2020-01-06T23:48:28.660547+00:00 app[api]: fi'` by user ylan@segal-family.com
2020-01-06T23:48:28.253359+00:00 app[api]: Running release v99 commands by user ylan@segal-family.com
2020-01-06T23:48:33.579124+00:00 heroku[release.9811]: Starting process with command `/bin/sh -c ... '"'"'bundle exec rake db:migrate'"'"' else   bundle exec rake db:migrate fi'`
2020-01-06T23:48:34.225131+00:00 heroku[release.9811]: State changed from starting to up
2020-01-06T23:48:36.000000+00:00 app[api]: Build succeeded
2020-01-06T23:48:40.262074+00:00 app[release.9811]: [1m[35m (1.5ms)[0m  [1m[34mSELECT pg_try_advisory_lock(5844823552245979560)[0m
2020-01-06T23:48:40.280848+00:00 app[release.9811]: [1m[35m (2.3ms)[0m  [1m[34mSELECT "schema_migrations"."version" FROM "schema_migrations" ORDER BY "schema_migrations"."version" ASC[0m
2020-01-06T23:48:40.298219+00:00 app[release.9811]: [1m[36mActiveRecord::InternalMetadata Load (1.7ms)[0m  [1m[34mSELECT "ar_internal_metadata".* FROM "ar_internal_metadata" WHERE "ar_internal_metadata"."key" = $1 LIMIT $2[0m  [["key", "environment"], ["LIMIT", 1]]
2020-01-06T23:48:40.314867+00:00 app[release.9811]: [1m[35m (1.6ms)[0m  [1m[34mSELECT pg_advisory_unlock(5844823552245979560)[0m
2020-01-06T23:48:40.419733+00:00 heroku[release.9811]: State changed from up to complete
2020-01-06T23:48:40.410205+00:00 heroku[release.9811]: Process exited with status 0
2020-01-06T23:48:41.931703+00:00 app[api]: Release v99 created by user ylan@segal-family.com
2020-01-06T23:48:42.257846+00:00 heroku[web.1]: Restarting
2020-01-06T23:48:42.274533+00:00 heroku[web.1]: State changed from up to starting
2020-01-06T23:48:43.021851+00:00 heroku[web.1]: Stopping all processes with SIGTERM
2020-01-06T23:48:43.032213+00:00 app[web.1]: [4] - Gracefully shutting down workers...
2020-01-06T23:48:43.304215+00:00 heroku[web.1]: Process exited with status 143
2020-01-06T23:48:46.489798+00:00 heroku[web.1]: Starting process with command `bundle exec puma -p 48278 -e production`
2020-01-06T23:48:48.340083+00:00 app[web.1]: [4] Puma starting in cluster mode...
2020-01-06T23:48:48.340107+00:00 app[web.1]: [4] * Version 4.3.1 (ruby 2.6.5-p114), codename: Mysterious Traveller
2020-01-06T23:48:48.340109+00:00 app[web.1]: [4] * Min threads: 5, max threads: 5
2020-01-06T23:48:48.340110+00:00 app[web.1]: [4] * Environment: production
2020-01-06T23:48:48.340115+00:00 app[web.1]: [4] * Process workers: 2
2020-01-06T23:48:48.340117+00:00 app[web.1]: [4] * Preloading application
2020-01-06T23:48:51.932771+00:00 app[web.1]: [4] * Listening on tcp://0.0.0.0:48278
2020-01-06T23:48:51.932941+00:00 app[web.1]: [4] Use Ctrl-C to stop
2020-01-06T23:48:51.939376+00:00 app[web.1]: [4] - Worker 0 (pid: 6) booted, phase: 0
2020-01-06T23:48:51.941703+00:00 app[web.1]: [4] - Worker 1 (pid: 9) booted, phase: 0
2020-01-06T23:48:52.360202+00:00 heroku[web.1]: State changed from starting to up
```

# TODO:
- [ ] add date
- [ ] Diagrams
- [ ] Finish content
  - [ ] Use heroku as an example of short-downtime deployment.
    -> Describe sequence of events
    https://devcenter.heroku.com/articles/release-phase
    -> Diagram
    -> How do rollbacks even work? How are migrations rolled back?
  - [ ] Preboot: https://devcenter.heroku.com/articles/preboot
    -> This is similar to Procore's deployment. Multiple versions of code are running at once.
    -> In this area talk about issues with different code running at once: Posting to non-existent endpoints,
      workers not having classes, etc.
- [ ] excerpt
