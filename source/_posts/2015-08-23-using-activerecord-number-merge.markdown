---
layout: post
title: "Using ActiveRecord::Base#merge"
date: 2015-08-23 11:24:16 -0700
comments: true
categories:
- rails
- ruby
---

The API for `ActiveRecord::Base` is very large, which makes it easy to miss some of the great convinences it affords.

``` ruby
class Account < ActiveRecord::Base
end

Account.new.methods.count # => 558
Object.new.methods.count # => 123
```

`ActiveRecord::Relation#merge` merges the conditions of two relations, allowing the use of scopes on both sides. This allows not repeating where clauses in separate places in the code base. Example, extracted from the [Rails documentation][1]:

``` ruby
# Instead of:

Post.joins(:comments).where(published: true, comments: { spam: false })

# => SELECT "posts".* FROM "posts" INNER JOIN "comments" ON "comments"."post_id" = "posts"."id" WHERE "posts"."published" = ? AND "comments"."spam" = ?  [["published", "t"], ["spam", "f"]]

# Lets take advantage of scopes in Post and Comment:

class Comment < ActiveRecord::Base
  scope :non_spam, -> { where(spam: false) }
end

class Post < ActiveRecord::Base
  scope :published, -> { where(published: true) }
end

Post
  .joins(:comments)
  .published
  .merge(Comment.non_spam)

# => SELECT "posts".* FROM "posts" INNER JOIN "comments" ON "comments"."post_id" = "posts"."id" WHERE "posts"."published" = ? AND "comments"."spam" = ?  [["published", "t"], ["spam", "f"]]
```

This way, each scope stays with the model it belongs in, removing any danger of duplicating domain logic (like what is consider spam) to a single place in the code. This technique is especially useful when taking advantage of more complicated (possibly parametized) scopes.

[1]: http://apidock.com/rails/ActiveRecord/SpawnMethods/merge
