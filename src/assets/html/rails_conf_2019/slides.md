layout: true

class: center, middle

---
background-image: url(images/portada.jpg)

???

???

- This is a story about a bug, but it's also about design.
- Welcome everyone!
- My name is Ylan, I'm originally from Mexico City, long-time San Diego resident.
- I've been writing code in some way or another for 20 years, and Rails since 2012.

---

background-image: url(images/procore_logo.svg)

???

I am a Staff Software Engineer at Procore

Procore Mission: Build the software to build the world.

We work on code that is used daily by thousands of construction professionals to help make their job better.

I love working at Procore. I am surrounded by smart, caring people, working on interesting problems. The live up to their values of Ownership, Openness and Optimism. Maybe you will love it too.

We are hiring: In Carpinteria, CA (headquarters), in Austin, TX and we are even starting an R&D team in Sydney, Australia.

Please stop by our booth if you want to hear more about it.

---
name: bug_1


# "When setting a user as inactive, the change is not reflected correctly in the API"

### -- The Customer

???

# The Bug

- Maybe the javascript front-end is not actually updating or ignoring errors
- Maybe caching
- Investigate if generically updates work.
- Look into logs of actual call by the customer. Why is it not updating

---
class: inverted
name: bug_2

# "The bug is confirmed, but only for accounts in the EU region"

### -- Support

???

- Wait, what? How is this a thing?
- EU region runs the same code, deploys at the same time.
- Maybe it got out of sync?

---
class: colored
name: bug_3

# "I can only recreate on staging environment with an enterprise account"

### -- QA

???

- The type of account doesn't have anything to do with this feature, it must be something completely different.
- At least in a staging server we have direct access to the database and full control of account.

---

```ruby
class Account < ActiveRecord::Base
  has_many :user_accounts
  has_many :users, _scope = nil, through: :user_accounts
end

class UserAccount < ActiveRecord::Base
  belongs_to :user
  belongs_to :account
end

class User < ActiveRecord::Base
  has_many :user_accounts
  has_many :accounts, _scope = nil, through: :user_accounts
end
```
???

- DISCLAIMER: "This code has been modified from its original version. It has been formatted to fit this screen and edited for content."

- As much as I want you to share my pain, I won't take you through all the dead ends. The journey was very painful, and you probably won't enjoy it.

---

name: original_controller

```ruby
class UsersController < ApplicationController
  def index
    users = SearchUsers.new(params).perform

    render json: users.map { |u|
      UserDecorator.new(u).to_h(current_account)
    }
  end
end
```

???

- `current_account` is provided somehow by ApplicationController

---

name: original_decorator

``` ruby
class UserDecorator
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def to_h(account)
    user_account = user.user_accounts.detect { |ua|
      ua.account_id = account.id
    }

    {
      id: user.id,
      first_name: user.given_name,
      last_name: user.family_name,
      email_address: user.primary_email,
      role: user_account.role,
      enabled: user_account.enabled?
    }
  end
end
```

???

- Decorator, or presenter.
- It serializes a user into a hash, for later conversion into JSON
- This is where the bug is found.

---

``` ruby
class UserDecorator
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def to_h(account)
    user_account = user.user_accounts.detect { |ua|
*     ua.account_id = account.id
*#                   ^---> o_O
    }

    {
      id: user.id,
      first_name: user.given_name,
      last_name: user.family_name,
      email_address: user.primary_email,
      role: user_account.role,
      enabled: user_account.enabled?
    }
  end
end
```
---

# The Missing Character

``` ruby
  ua.account_id = account.id
#
  ua.account_id == account.id
#               ^--> :-)

```

???

- Instead of checking for equality, we are assigning the account.id to the first user_account
- It returns truthy, so the first user_account loaded is selected always.
- Why was this so hard to replicate?
  - Any "second" account would trigger this behavior

---

# The Plot Thickens

``` ruby
SecureRandom.uuid # => "34a22bb9-e648-4264-ad13-3fbb07e9efc6"
SecureRandom.uuid # => "8b355635-ab2a-4b3e-936d-cbec824ab48d"
SecureRandom.uuid # => "39b2bc99-ee56-41e1-9e08-cc2cd65bc374"
```

???

- Id's in the app are UUIDs.
- Ordering is by id by default. With auto-increments this mostly correlates to creation time. Using UUIDs that is not true at all.
- Not a lot of users belong to more than one account.
- Not a lot of users have different roles or are disabled.
- Not a lot of our customers check in the public API!

---

class: inverted

# A Failing Test

- A `user` belonging to multiple `account` s

- Different values for `role` and `enabled?`

- Loaded in the correct order

???

- `role` and `enabled?` are the properties from the user_account

---

# A Failing Test in RSpec

``` ruby
describe UserDecorator do
  subject { described_class.new(user) }

  it "returns the role name for the user_account" do
    expect(subject.to_h(account)[:role]).to eq(role)
  end

  it "returns the enabled value for the user_account" do
    expect(subject.to_h(account)[:enabled]).to eq(enabled)
  end
end
```

???

NameError: undefined local variable or method

---

# A Failing Test in RSpec

``` ruby
describe UserDecorator do
  subject { described_class.new(user) }
* let(:user) { FactoryGirl.create(:user, accounts_count: 2) }
* let(:role) { :admin }
* let(:enabled { false }

  it "returns the role name for the user_account" do
    expect(subject.to_h(account)[:role]).to eq(role)
  end

  it "returns the enabled value for the user_account" do
    expect(subject.to_h(account)[:enabled]).to eq(enabled)
  end
end
```

???

- Defining user, role and enabled are straighforward.

---

# A Failing Test in RSpec

``` ruby
describe UserDecorator do
  subject { described_class.new(user) }
  let(:user) { FactoryGirl.create(:user, accounts_count: 2) }
  let(:role) { :admin }
  let(:enabled { false }
* let(:account) {
*   # We need to test on the last account  
*   user.user_accounts.last.tap { |user_account|
*     user_account.update!(role: role, enabled: enabled)
*   }.account
* }

  it "returns the role name for the user_account" do
    expect(subject.to_h(account)[:role]).to eq(role)
  end

  it "returns the enabled value for the user_account" do
    expect(subject.to_h(account)[:enabled]).to eq(enabled)
  end
end
```

???

- We need to test the last account (or any other but the first).
---

# A Failing Test in RSpec

``` ruby
describe UserDecorator do
  subject { described_class.new(user) }
  let(:user) { FactoryGirl.create(:user, accounts_count: 2) }
  let(:role) { :admin }
  let(:enabled { false }
  let(:account) {
    # We need to test on the last user_account  
    user.user_accounts.last.tap { |user_account|
      user_account.update!(role: role, enabled: enabled)
    }.account
  }

* before {
*   # Expose bug by setting different values on the first one
*   user.user_accounts.first.tap { |user_account|
*     user_account.update!(role: :other, enabled: !enabled)
*   }
* }
end
```

???

- To ensure a reliable spec (no intermittent failures, the root of all CI evil) we need to make sure that the first account has *different* values, which exposes then bug.
- This creates a spec that fails to the "right" reasons and exposes the exact bug
---

# PR

```diff
- user_account = user_accounts.detect { |ua|
-  ua.account_uid = account.uid
- }
+ user_account = user_accounts.where(account: account).first
```

Let the database do the work!

???

- My thought process: Why are we doing this in Ruby? The database is *much* faster at this.

---

class: colored

# PR: The comment

## Do we know why it was like that in the first place?

.emoji[
😨
]

???

# PR: The comment

- Sinking feeling: Did I miss something?
---

# Commit Message

```markdown
commit 647793f44784b59d00df3cbb97ea4833e944837e



  Find correct user_account in ruby for performance...

  The user_accounts are already preloaded, but ActiveRecord goes
  to the database again, which causes an N+1 query. In this
  case, doing the filtering in Ruby is more efficient.
```

???

- Sense of satisfaction is short lived
- The commit message signals that there are dragons.
- The original author clearly knows that the code is unusual.
  - Before reading this message I assumed that the author did not know what he was doing.
  - After reading, it seems that he was making some trade-offs.
- The commit comment provides valuable information.
- Who is this sage, this wise person?

---

# Commit Message

```markdown
commit 647793f44784b59d00df3cbb97ea4833e944837e
* Author: Ylan Segal


  Find correct user_account in ruby for performance...

  The user_accounts are already preloaded, but ActiveRecord goes
  to the database again, which causes an N+1 query. In this
  case, doing the filtering in Ruby is more efficient.
```

???

- I was smart enough to leave a comment for my future self, but not smart enough to read it.
- Or for that matter write the correct code

---

name: smells_1
class: colored

# Design Smells

???

- Back to doing the filtering in Ruby
- The bug is fixed, but we have a few things that are giving me pause.

---

name: smells_2
class: inverted

# Complicated Spec Setup

???

- Overly complicated setup can point to a class doing to many things, leaky abstraction, etc.

---

name: smells_3

# Loading **more** from the database is **faster**.

???

- This is counter intuitive and contradicts years of experience.
- Filtering in Ruby is slower because there is more overhead:
  - More data through network
  - More object instantiation

---

name: smells_4
class: colored

# Irregular code shape / structure.

???

- Decorator is not the right shape

- How do we proceed? The easiest improvement we can do is in the decorator. Let's make it the right shape

---

template: original_decorator

---

``` ruby
class UserDecorator
* attr_reader :user, :account

* def initialize(user, account)
    @user = user
*   @account = account
  end

* def to_h
    user_account = user.user_accounts.detect { |ua|
      ua.account_id == account.id
    }

    {
      id: user.id,
      first_name: user.given_name,
      last_name: user.family_name,
      email_address: user.primary_email,
      role: user_account.role,
      enabled: user_account.enabled?
    }
  end
end
```

???

- Move the decorated objects to the intializer
- `to_h` now has the same signature (arity) as other decorators in the system

---

``` ruby
class UserDecorator
  attr_reader :user, :account

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

* private

* def user_account
*   @user_account ||= user.user_accounts.detect { |ua|
*     ua.account_id == account.id
*   }
*  end
```

???

- to_h is simpler
- All collaborators are passed in initializer
- The user_account finding is now it's own thing.
- Refactoring is changing the internal structure. Is this it? Changes the API of the object.

- Notice the initializer: A `user` and an `account` is a `user_account` !
  That is the insight we need, to noticed that we are not decorating the right object.
---

# Decorate the right object

``` ruby
class UserAccountDecorator
  attr_reader :user_account
  delegate :user, to: :user_account

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
end
```

???

- This decorator is much improved.
- There is no finding / loading in this class
- Let's see if we can plug it in our controller


---

template: original_controller

???

- Our original controller looked like this

---

# Move the pain

```ruby
class UsersController < ApplicationController
  def index
    users = SearchUsers.new(params).perform

    render json: users.map { |u|
*     user_account = u.user_accounts.detect { |ua|
*       ua.account_id == account.id
*     }
*     UserAccountDecorator.new(user_account).to_h
    }
  end
end
```

???

We've moved the pain, but we still have the same issue.
We've actually made it worse, because now we have logic in our controller.
Where else can we move this to?

- Explicitly using two classes. Can it go on the other?

---

# Controller: A Closer Look

``` ruby
class UsersController < ApplicationController
  def index
*   users =
*     SearchUsers.new(params).perform.preload(:user_accounts)
    render json: users.map { |u|
      user_account = u.user_accounts.detect { |ua|
        ua.account_id == account.id
      }
      UserAccountDecorator.new(user_account).to_h
    }
  end
end
```

???

- We have not seen what happens in SearchUsers.
- We are preloading *all* of the `user_account` objects.
- `#preload` interferes with our decorator: It brings in data from other accounts, not just the one in scope. That is *bad*

---

# Load the right objects

``` ruby
class UsersController < ApplicationController
  def index
    user_accounts = SearchUserAccounts.new(params).perform

    render json: user_accounts.map { |ua|
      UserAccountDecorator.new(ua).to_h
    }
  end
end
```

???

- No extra loading from the database.
- Decorator is sticking to its responsibilities.
- Simetry between search class and decorator
- We didn't need to see all of the refactoring at once to know where it would lead.
  We did small changes to improve local code, that ended improving the overall design.
- Sometimes you hit some dead ends.

---

class: inverted

# Five Factor Testing - Sarah Mei

https://www.devmynd.com/blog/five-factor-testing/

1. Verify the code is working correctly
2. **Prevent future regressions**
3. Document the code’s behavior
4. Provide design guidance
5. Support refactoring

???

---
class: colored
# Where do I put the regression test?

???

- We had written a regression test
- The class it was on is now no longer in the code path: We are now using a different decorator.
- It was in the decorator, but that decorator is no longer in use.
- Move to the controller? Request spec?
- If we move to controller it's painful, but may be worth it.
- There is a better place: The problems was with data loading, so we should test there.

---

# Test when loading

``` ruby
describe SearchUserAccounts do
  let(:user) { FactoryGirl.create(:user, accounts_count: 2) }
  let(:user_account) { user.user_accounts.first }
  let(:params) { { account_id: user_account.account_id } }
  subject { described_class.new(params) }

  let(:other_user_account) { user.user_accounts.last }

  it "loads user_accounts belonging to the scoped account" do
    expect(subject.perform).to include(user_account)
    expect(subject.perform).not_to include(other_user_account)
  end
end
```

???

- The spec is relatively straight forward.
- It deals with data loading, which is the class' responsibility

---
class: inverted
# A bug is an opportunity for improvement

???

# Conclusions
---

# Better design:

???

- My contention is that the new design is better.

---
class: inverted
# Better design:
# Follows patterns

???

- It fits better with the rest of the system.
- Less surprises to for others working on it
- Convention over configuration, shared understanding

---

# Better design:
# Small pieces, easier to understand

???

- Each piece is easier to understand on it's own

---
class: colored

# Better design:
# Abstractions, not just indirection

???

- Reduced mental load, because responsibilities are better defined
- You can stop thinking about the implementation details.

---

# Testing

???

- We talked about testing a lot
- Regression testing
- Informs design
- Allows refactoring with confidence and safety
- If we hadn't had good testing suite, the refactoring would more than likely not have taken place.

---
background-image: url(images/contraportada.jpg)
