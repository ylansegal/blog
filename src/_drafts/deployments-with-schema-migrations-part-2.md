---
layout: post
title: "Deployments With Schema Migrations, Part 2"
# date: 2020-01-14 16:26:07 -0800
categories:
- deployment
- rails
- heroku
# excerpt:
---

In a previous post, I proposed a method for reasoning about when to run migrations during different types of deployments. The example we used was a purely additive migration, in the sense that only new things were added, nothing removed. Let's explore a different type of migration.

# Another feature

In our new example, we want to stop displaying and accepting a `rating` field in our post model. Our initial code (`V0`) is as follows:

```ruby
# V0
class Post < ActiveRecord::Base
end

# ... somewhere in a view
post.rating
```

```ruby
# db/schema.rb - S0
create_table "posts", force: :cascade do |t|
  t.text "title"
  t.text "body"
  t.integer "rating"
  t.datetime "created_at", precision: 6, null: false
  t.datetime "updated_at", precision: 6, null: false
end
```

After our code changes, our code (`V0`) and our schema state (`S1`) will have changed to:

```ruby
class Post < ActiveRecord::Base
end

# db/migrate/202001245001321_remove_rating_column.rb
class RemoveRatingColumn < ActiveRecord::Migration[6.0]
  def change
    remove_column :posts, :rating, :integer
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
```

The changes are straightforward: We write a migration to remove the column and remove all usage of it in the code. How do we deploy this? In our previous post we saw several modes of deployment, all of which relied in our previous analysis of _when_ it was safe to run the migration. Let's do the same now.

`V0`-`S0` is known to work: This is our initial condition and the status quo. `V1`-`S1` is also known to work: Our tests ensure that. This configuration is what we test in our development environment.

`V0`-`S1` can be tested. If we create a testing branch that _only_ contains the migrations -- but no code changes -- we should see failures related to the code attempting to use `post.rating` when that column doesn't exist.

For `V1`-`S0` we can also create a test branch for this configuration and run our specs. None of our code is expecting the `rating` field to exist, so our specs pass, making this a viable configuration.

We can tabulate the above in a compatibility matrix:

|          | `S0` | `S1` |
|:--------:|:----:|:----:|
| **`V0`** |  ✓   |  𐄂  |
| **`V1`** |  ✓   |  ✓   |

The above results lead us to conclude that the migration needs to run when only `V0` has been swapped for `V1` completely.

Our fictional instantaneous deployment will then look like this:

{% include figure.html url="/assets/images/diagrams/part2_instant_deployment.png" description="Fig 1: Instantaneous Deployment" %}


###########################################

# TODO
- [ ] Is V1-S0 safe? Replicate how the cached column definition gets in the way. In what type of query? Is it only in Postgres? In SQLite it doesn't actually seem to be a problem.

---

```ruby


class Post < ActiveRecord::Base
end

Post.connection;

Post

ActiveRecord::Migration[5.2].remove_column :companies, :rating, :integer

ActiveRecord::Migration[5.2].add_column :companies, :rating, :integer

---


class C < ActiveRecord::Base
  self.table_name = "companies"
end

C
# => C (call 'C.connection' to establish a connection)

C.connection;
# => C(id: integer, created_at: datetime, updated_at: datetime, qbwc_token: string, qwc_owner_id: string, login: string, password_digest: string, name: string, customer_is_a_job: boolean, procore_url: string, last_connection: datetime, next_purge_time: datetime, retain_requests: integer, qwc_file_id: string, qb_file_path: string, custom_metadata_configurations: jsonb, procore_company_id: integer, credentials_valid: boolean, procore_standard_cost_code_list_id: integer, procore_client_id: string, procore_client_secret_digest: string, qb_canada: boolean, use_sync_schedule: boolean, status: text, rating: integer)

ActiveRecord::Migration[5.2].remove_column :companies, :rating, :integer

# $ ERROR:  cached plan must not change result type
# STATEMENT:  SELECT  "companies".* FROM "companies" ORDER BY "companies"."id" ASC LIMIT $1


C.first.rating
#   C Load (0.4ms)  SELECT  "companies".* FROM "companies" ORDER BY "companies"."id" ASC LIMIT $1  [["LIMIT", 1]]
# ActiveModel::MissingAttributeError: missing attribute: rating

# However, rating would have already been removed. How do I trigger with new code?
```

Reference:

https://pedro.herokuapp.com/past/2011/7/13/rails_migrations_with_no_downtime/

> PGError: ERROR: column "notes" does not exist

> Turns out that ActiveRecord caches table columns, and uses this cache to build INSERT statements. Even if the code is not touching that column, ActiveRecord will still attempt to set it to NULL when saving models.


Re-create:


```ruby

ActiveRecord::Migration[5.2].create_table :posts do |t|
  t.text :title
  t.text :body
  t.timestamps
  t.integer :rating
end

class Post < ActiveRecord::Base
end

Post.connection;
Post
# => Post(id: integer, title: text, body: text, created_at: datetime, updated_at: datetime, rating: integer)

Post.create!
# => #<Post:0x00007fcb62875b38
#  id: 1,
#  title: nil,
#  body: nil,
#  created_at: Mon, 27 Jan 2020 22:58:02 UTC +00:00,
#  updated_at: Mon, 27 Jan 2020 22:58:02 UTC +00:00,
#  rating: nil>


ActiveRecord::Migration[5.2].remove_column :posts, :rating, :integer

Post.create!
# (0.2ms)  BEGIN
# Post Create (0.5ms)  INSERT INTO "posts" ("created_at", "updated_at") VALUES ($1, $2) RETURNING "id"  [["created_at", "2020-01-27 22:58:29.408321"], ["updated_at", "2020-01-27 22:58:29.408321"]]
# (5.7ms)  COMMIT
# => #<Post:0x00007fcb62a39988
#  id: 2,
#  title: nil,
#  body: nil,
#  created_at: Mon, 27 Jan 2020 22:58:29 UTC +00:00,
#  updated_at: Mon, 27 Jan 2020 22:58:29 UTC +00:00,
#  rating: nil>

Post.last
#   Post Load (0.4ms)  SELECT  "posts".* FROM "posts" ORDER BY "posts"."id" DESC LIMIT $1  [["LIMIT", 1]]
# => #<Post:0x00007fcb62a9a080
#  id: 2,
#  title: nil,
#  body: nil,
#  created_at: Mon, 27 Jan 2020 22:58:29 UTC +00:00,
#  updated_at: Mon, 27 Jan 2020 22:58:29 UTC +00:00>


ActiveRecord::Migration[5.2].drop_table :posts
```

Looks like the issue may have been fixed at some point, since the other article was written (2011).
