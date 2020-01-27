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


# TODO
- [ ] Is V1-S0 safe? Replicate how the cached column definition gets in the way. In what type of query? Is it only in Postgres? In SQLite it doesn't actually seem to be a problem.
