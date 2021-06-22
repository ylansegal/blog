---
layout: post
title: "Better Form Objects in Rails"
date: 2021-06-22 15:10:48 -0700
categories:
- rails
excerpt_separator: <!-- more -->
---

`ActiveModel` was introduced in Rails with the promise of being able to create model classes that interact well with the rest of the Rails ecosystem (e.g. routing, forms), but are not backed by a database table.

It has some shortcomings, which are addressed by the `active_type`. Let's look at an example.

<!-- more -->

# A Search Resource

Let's assume that we are working on a RESTful Rails system, and we are asked to add a search form. A `Search` object is a useful concept: It can encapsulate a few fields on a form filled by the user, and submitted to the server for processing.

A minimal implementation can look like this:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  resources :searches, only: %i[new create]
end

# app/controllers/searches_controller.rb
class SearchesController < ApplicationController
  def new
    @search = Search.new
  end

  def create
    search = Search.new(params.permit(search: :terms)[:search])
    if search.valid?
      # perform search
    else
      render "new"
    end
  end
end

# app/models/search.rb
class Search
  include ActiveModel::Model

  attr_accessor :terms

  validates :terms, presence: true
end
```

```erb
# app/views/searches/new.html.erb
# Uses the excellent simple_form gem
<%= simple_form_for @search do |f| %>
  <%= f.error_notification %>
  <%= f.input :terms %>
<% end %>
```

In this example, we have a `Search` model that for now defines a single field (`terms`) and validates its presence. It works well with the rest of the Rails ecosystem, since we can easily create a form with it, that handles routing, data validation, etc. The matter of actually performing the search is outside the scope of this post.

So far, `ActiveModel` has proven very useful, but our form is particularly simple. Let's add a `modified_since` field, and see how we fare:

```ruby
class Search
  include ActiveModel::Model

  attr_accessor :terms
  attr_accessor :modified_since

  validates :terms, presence: true
  validates :modified_since, presence: true
end
```

```erb
<%= simple_form_for @search do |f| %>
  <%= f.error_notification %>
  <%= f.input :terms %>
  <%= f.input :modified_since %>
<% end %>
```

The first issue is that `modified_since` is rendered as a text input, not a date. Since there is no type information, `simple_form` can't infer what we want. We can solve that by giving it a hint:

```erb
<%= simple_form_for @search do |f| %>
  <%= f.error_notification %>
  <%= f.input :terms %>
  <%= f.input :modified_since, as: :date %>
<% end %>
```

With that in place, `simple_form` will create 3 drop-downs to select year, month and date. When submitted, those appear as separate parameters:

```ruby
params.permit(search: [:terms, :modified_since])
# => #<ActionController::Parameters {"search"=>#<ActionController::Parameters {"terms"=>"", "modified_since(1i)"=>"2021", "modified_since(2i)"=>"6", "modified_since(3i)"=>"22"} permitted: true>} permitted: true>
```

For database-backed models (e.g. those inheriting from `ActiveRecord::Base`), Rails knows how to handle those 3 date parameters and instantiate a date correctly. However, `ActiveModel` does not:

```ruby
Search.new(params.permit(search: [:terms, :modified_since])[:search])
# ActiveModel::UnknownAttributeError: unknown attribute 'modified_since(1i)' for Search
```

We can manually parse those parameters into a `Date`, but that is clearly reinventing the wheel. This is where the [active_type gem](https://github.com/makandra/active_type) comes in. It allows defining attributes on a model with a type associated with it.

```ruby
class Search < ActiveType::Object
  attribute :terms, :string
  attribute :modified_since, :date

  validates :terms, presence: true
  validates :modified_since, presence: true
end

```

```ruby
@search = Search.new(params.permit(search: [:terms, :modified_since])[:search])
# => #<Search modified_since: "2021-06-22", terms: "asdas">

@search.terms
# => "asdas"

@search.modified_since
# => Tue, 22 Jun 2021
```

# Conclusion

`active_type` does the heavy lifting and makes much better form objects than `ActiveModel`. In fact, for a long time I assumed that Rails already had this built-in!
