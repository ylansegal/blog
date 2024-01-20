---
layout: post
title: "Convention Over Configuration, But Not For Style"
date: 2024-01-20 14:48:11 -0800
categories:
- ruby
- rails
excerpt_separator: <!-- more -->
---

Recently DHH added [Rubocop](https://github.com/rails/rails/issues/50456) by default to Rails, and posted about his decision in a [A writer's Ruby](https://world.hey.com/dhh/a-writer-s-ruby-2050b634) blog post:

> Some languages, like Go, have a built-in linter, which applies a universal style that’s been set by the language designers. That’s the most totalitarian approach. A decree on what a program should look like that’s barely two feet removed from a compile error. I don’t like that one bit.

> It reminds me of Newspeak, the new INGSOC language from Orwell’s 1984. Not because of any sinister political undertones, but in the pursuit of a minimalist language, with no redundant terms or ambiguities or flair. Imagine every novel written in the same style, Hemingway indistinguishable from Dickens, Tolkien from Rowling. It would be awfully gray to enjoy the English language if there was only a single shade of prose.

>  The best code to me is indeed its own form of poetry, and style is an integral part of such expression. And in no language more so than Ruby.

> There are probably people who would prefer the more conventional, literal style, and they could encode that preference in a lint rule. I’d have absolutely no problem with that, as long as they’re not trying to force me to abide by their stylistic preferences.

Now, in [The Rails Doctrine](https://rubyonrails.org/doctrine#convention-over-configuration) DHH writes about [Convention over Configuration](https://rubyonrails.org/doctrine#convention-over-configuration):

> One of the early productivity mottos of Rails went: “You’re not a beautiful and unique snowflake”. It postulated that by giving up vain individuality, you can leapfrog the toils of mundane decisions, and make faster progress in areas that really matter.

> Who cares what format your database primary keys are described by? Does it really matter whether it’s “id”, “postId”, “posts_id”, or “pid”? Is this a decision that’s worthy of recurrent deliberation? No.

---

Let me try to unpack the two posts. Table names and primary and foreign key columns have strong conventions in Rails:

```ruby
class Post < ApplicationRecord
  has_many :comments
end

class Comment < ApplicationRecor
  belongs_to :post
end
```

Implicit in the code above is that our database has a table `posts` with a primary key field `id`, and a table named `comments` with a primary key field `id` and a foreign key `post_id` referencing `posts.id`. There are many arguments to make about these specific conventions: About the plural table names, about using snake case, about the Ruby class names being singular, etc. The point over convention over configuration is that those changes don't matter. The convention saves of from making unimportant decisions, in DHH words:

> Part of the Rails’ mission is to swing its machete at the thick, and ever growing, jungle of recurring decisions that face developers creating information systems for the web. There are thousands of such decisions that just need to be made once, and if someone else can do it for you, all the better.

Let's get back to Ruby syntax. The argument seems to be that the following two ways of writing the same code are different forms of self expression and the building blocks of poetry:

```ruby
has_many :posts

has_many(:posts)
```

I am not convinced by that argument. I [used to think]({% post_url 2016-12-22-enforcing-style %}) that creating a style-guide for each team was a worthwhile exercise. Since then, I've been on 3 different teams in 12 years (hardly a lot by tech standards). I've come to experience the power of hitting the ground running on an unfamiliar Rails application, **exactly** because of convention over configuration. I'd rather we have more of that, with a convention for code style *across* teams.

In [A writer's Ruby](https://world.hey.com/dhh/a-writer-s-ruby-2050b634), DHH says:

> Imagine every novel written in the same style, Hemingway indistinguishable from Dickens, Tolkien from Rowling. It would be awfully gray to enjoy the English language if there was only a single shade of prose.

That would be an awful world indeed, but I don't think it's a fair comparison. Novels are mostly individual works of art. Code style is mostly a team endeavour with very different goals than literary works. Presumably, the team is working towards producing a maintainable code base that is easy to work on by current **and** future members of the team. Predictable style and idioms are better than poetic code. I would hate for all the novels I read to have the same style. I would hate just as much for the instructions on my dishwasher to be in the style of James Joyce or Leo Tolstoy.

For now, I am using [standardrb](https://github.com/standardrb/standard), even if I don't like all the conventions.
