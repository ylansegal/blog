---
layout: post
title: "Bug-Driven Development"
date: 2017-09-21 08:52:21 -0700
comments: true
categories:
- ruby
- design
---

## The Bug

The other day, I got a bug report from our customer service team. One of our newest customers was using our public API and reporting inconsistencies for our endpoint that lists account users. The issue was that for *some* users, their role in the account and their active flag was being reported incorrectly -- compared with the value visible through our web interface. This was surprising: That endpoint has been in place for years and is used regularly by many of our customers. Nonetheless, the customer support team had verified the report from the customer and I had examples of the JSON output from their API interactions.

The code base for this projects is a mono-Rails application. I've worked on it for more than five years. It has evolved significantly throughout the years (including the addition of the public API in question). It has been worked on by more than a dozen engineers. The root cause of the bug could be anywhere. My go-to move in this kind of situation is to reproduce in the development environment, following the rule-of-thumb that reproducing an issue is half the battle. In this case, reproducing the bug was extremely painful. I spot checked the API call for some of my users in my development environment and -- with QA's help -- tested on a staging environment. I finally found *some* instances of the issue, but it wasn't at all clear to me what the root cause was.

Next, I took a dive through the code. I followed the code starting from the controller action in question and followed the calls all the way to the database and back. Eventually, I found the problem in a decorator class of all things. In this particular project, we use classes to serialize responses into hashes and then let rails serialize those into JSON. The code is functionally similar to this[^1]:

```ruby
class UsersController < ApplicationController
  def index
    @users = #... somehow load users.
    render json: @users.map { |u| UserDecorator.new(u).to_h(current_account) }
  end
end

class UserDecorator
  def initialize(user)
    @user = user
  end

  def to_h(account)
    user_account = user.user_accounts.detect { |ua| ua.account_id = account.id }

    {
      id: user.id,
      first_name: user.given_name,
      last_name: user.family_name,
      email_address: user.primary_email,
      role: user_account.role,
      enabled: user_account.enabled?
    }
  end

  private

  attr_reader :user
end
```

The above code does some mapping between our internal names for some fields and what we decided to call them in the public API. It also includes some information from the `UserAccount` model. Spot the bug yet? I didn't.

The `user`, `account` and `user_account` models in question are typical `ActiveRecord` models. The relevant pieces look like this:

```ruby
class Account < ActiveRecord::Base
  has_many :user_accounts
  has_many :users, nil, through: :user_accounts
end

class UserAccount < ActiveRecord::Base
  belongs_to :user
  belongs_to :account
end

class User < ActiveRecord::Base
  has_many :user_accounts
  has_many :accounts, nil, through: :user_accounts
end
```

If you are a keen reader, you probably noticed the same thing I did: In the decorator code `user.user_accounts` will return an `ActiveRecord::Relation`. Why is the code filtering for that relation in Ruby? Why is the work being done after loading the `ActiveRecord` objects instead of filtering in the much-more efficient database? While I was pondering at, it finally hit me: The block inside of `detect` should be using a `==`

```ruby
user_account = user.user_accounts.detect { |ua| ua.account_id = account.id }
# Should really be
user_account = user.user_accounts.detect { |ua| ua.account_id == account.id }
```

What is happening? Instead of *finding* the user_account that corresponds to the passed in account, the code block is *assigning* a new `account_id` to the `UserAccount`. The assignment in ActiveRecord returns the same assigned value, the account id in this case. That value is truthy, so the `detect` call always returns the first user_account read from the database. By default, ActiveRecord will load the records in an association ordered by the primary key (i.e. id). In our case, this made the detection of the code particularly tricky. When using auto-incrementing ids -- the default Rails case -- the first account returned will also be the first account inserted: I had considered that as a possible cause for the bug, but rejected it because it didn't fit my observations on production or staging servers. What I neglected to consider was that our models do not use auto-increment ids: They use UUIDs, stored in the database as strings and generated by `SecureRandom`. This throws-off any ordering:

```ruby
SecureRandom.uuid # => "34a22bb9-e648-4264-ad13-3fbb07e9efc6"
SecureRandom.uuid # => "8b355635-ab2a-4b3e-936d-cbec824ab48d"
SecureRandom.uuid # => "39b2bc99-ee56-41e1-9e08-cc2cd65bc374"
```

## The Fix

At this point, I was ready to create a failing test case that exposes the bug: We need a user with multiple `UserAccount`s (and thus multiple `Account`s), we need the `UserAccount` to have different values for `role` and `enabled?`, and we need for them to be loaded in the correct order from the database so that we can expose the bug. My tests looks something like this:

```ruby
describe UserDecorator do
  subject { described_class.new(user) }
  # This project uses FactoryGirl for model factories, instead of Rails' fixtures.
  let(:user) { FactoryGirl.create(:user, accounts_count: 2) }
  let(:user_account) {
    # We need the last user_account to be the one that we check for
    user.user_accounts.last.tap { |user_account|
      user_account.update!(role: role, enabled: true)
    }
  }
  let(:account) { user_account.account }
  let(:role) { :admin }

  before {
    # We need the first user account to have different values, so that it exposes the bug
    user.user_accounts.first.tap { |user_account|
      user_account.update!(role: :other, enabled: false)
    }
  }

  it "returns the correct role name for the user_account" do
    expect(subject.to_h[:role]).to be == role
  end

  it "returns the correct enabled value for the user_account" do
    expect(subject.to_h[:enabled]).to be == true
  end
end
```

With the bug exposed, I was committed a fix and opened a pull request, figuring I would fix the bug and get better performance by limiting the number of ActiveRecord objects loaded from the database.

```ruby
# This:
user_account = user_accounts.detect { |ua| ua.account_uid = account.uid }
# Became
user_account = user_accounts.where(account: account).first
```

I wasn't quite done. One of my co-workers pointed out that there was a reason that the code was using Ruby to filter the user_accounts. The previous commit message -- the one that brought the Ruby filtering -- had a helpful message that I neglected to read:

```
Find correct user_account in ruby for performance...

The user_accounts are already preloaded, but ActiveRecord goes
to the database again, which causes an N+1 query. In this case,
doing the filtering in Ruby is more efficient
```

I shouldn't have assumed that the person that coded the filtering in Ruby was doing it wrong. In this case, there seem to be a good reason behind the unusual code. By the way, the author of that previous commit was me in 2015. I was smart enough to leave a note for my future self, but not humble enough to read it.

## Design Implications

The bug is now fixed, yet I am not quite comfortable with the code. Two things bother me:

1. The specs needs a relatively complicated setup to expose the bug
2. The production code is loading *more* objects from the database, only to discard them in Ruby. This somehow is *faster*.

Why is a our test complicated? A decorator is supposed to be a simple class. It really is about serializing an object into JSON. The class is called a `UserDecorator`. It's instantiated with `User`, which makes total sense. However, we have two collaborators that snuck-up on the serialization. An instance of `Account`, being passed in and a `UserAccount` that we find based on the other two. Where does the account come from? Originally, I glossed over how the users are loaded. The code is a bit complicated because it searches the database based on the parameters passed in. However, in it's simplest form and removing a few layers of abstraction, it's functionally equivalent to:

```ruby
class UsersController < ApplicationController
  def index
    @users = SearchUsers.new(params).perform.preload(:user_accounts)
    render json: @users.map { |u| UserDecorator.new(u).to_h(current_account) }
  end
end
```

It's not particularly important how `SearchUsers` works, but it's sufficient to know that `#perform` returns an `ActiveRecord::Relation` that will load `User` records upon execution. The preloading here is what causes the user_accounts perviously alluded to in the commit message to be already loaded. If we stop to think about it, something else tickles my code nose: If we are searching for users within an account, and then pre-loading all *user_accounts* for those users, we are loading *some* data for other accounts. This is unacceptable. On requests that are account-scoped, like this one, data for other other accounts should never be loaded from the database.

Coming back to our decorator: Why are we even passing a parameter to the method? If `#to_h` is supposed to just construct a hash, let's make the code just do that:

```ruby
class UserDecorator
  def initialize(user, account)
    @user = user
    @account = account
  end

  def to_h
    {
      id: user.id,
      first_name: user.given_name,
      last_name: user.family_name,
      email_address: user.primary_email,
      role: user_account.role,
      enabled: user_account.enabled?
    }
  end

  private

  attr_reader :user, :account

  def user_account
    @user_account ||= user.user_accounts.detect { |ua| ua.account_id == account.id }
  end
```

This is better: It moves the searching for a user account out on it's own method. It also now needs a user *and* an account to initialize the decorator. A `User` and an `Account` together are... a `UserAccount`. And at this point, is where the flaws in the original design become evident. We are searching for, decorating and listing users, but working in an account scope. This concept already exists in our system, in the form of the a `UserAccount` and we should be leveraging it:

```ruby
class UsersController < ApplicationController
  def index
    @users = SearchUserAccounts.new(params).perform
    render json: @users.map { |u| UserAccountDecorator.new(u).to_h }
  end
end

class UserAccountDecorator
  def initialize(user_account)
    @user_account = user_account
  end

  def to_h
    {
      id: user.id,
      first_name: user.given_name,
      last_name: user.family_name,
      email_address: user.primary_email,
      role: user_account.role,
      enabled: user_account.enabled?
    }
  end

  private

  attr_reader :user_account

  def user
    user_account.user
  end
end
```

This is markedly better. We are not loading extra objects from the database anymore. The only `UserAccount`s loaded are the ones pertaining to the account in scope. The decorator now doesn't know or care about how the user_accounts are loaded. As always, we need to be careful that we don't introduce N+1 queries when the user_account reaches out to the user. A judicious user of `ActiveRecord::Relation#includes` can take care of that.

What about the complicated spec setup? Well, we got rid of the `UserDecorator` and it's specs. [Sarah Mei writes about][testing] testing serving many purposes or -- as she calls them -- factors. One of those is informing our design. Our specs above clearly did that: The complicated setup lead to the realization that we were dealing with the wrong data model.

Another test factor is to prevent future regressions. The same issue we had before is unlikely to crop-up again in the new design. However, production bugs are to be taken seriously -- especially ones where data is being improperly reported for an account. Where should this regression-prevention spec live? We could move it to the controller and make it an integration spec of sorts. I expect the setup to be at least as complicated as the one shown above -- and quite possible much worse. Rails controllers are notoriously difficult to test. I would gladly pay that price before laving no regression spec in place, though.

Fortunately, there is a better place for our complicated spec: `SearchUserAccounts`. As the name implies, this class' responsibility is to load data from our database based on the input in the `params`. I haven't shown that code at all, but I hope it's clear that it deals with the ActiveRecord querying API. This is the correct level to test that *only* the correct data has been loaded. The regression spec then becomes:

```ruby
describe SearchUserAccounts do
  subject { described_class.new(params) }
  let(:params) { { account: account } }
  let(:account) { user_account.account }
  let(:user_account) { user.user_accounts.first }
  let(:user) { FactoryGirl.create(:user, accounts_count: 2) }

  let(:other_user_account) { user.user_accounts.last }

  it "only loads user_accounts belonging to the scoped account" do
    aggregate_failures do
      expect(subject.perform).to include(user_account)
      expect(subject.perform).not_to include(other_user_account)
    end
  end
end
```

The spec is now simpler and testing at the correct level of abstraction.

## Conclusion

Fixing bugs is a part of programming. Sometimes, they are simple and emerge because of our failure to consider all inputs or internal state. I hope that the takeaway for you, the reader, is that sometimes bugs can expose subtle design deficiencies. Improving the design can do much more than just fix the bug: It can bring simplicity to both the production code and it's tests.

[^1]: All the code in this post is inspired by actual production code in a project I work on. It has been simplified considerably to make it easier to follow, protect copyright, and make it easier for the reader to see the proverbial forest for the trees.
[testing]: https://www.devmynd.com/blog/five-factor-testing/
