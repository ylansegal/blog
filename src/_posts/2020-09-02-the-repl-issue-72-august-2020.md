---
layout: post
title: "The REPL: Issue 72 - August 2020"
date: 2020-09-02 14:06:48 -0700
categories:
- the repl
excerpt_separator: <!-- more -->
---

### [Error handling with Monads in Ruby](http://nywkap.com/programming/either-monads-ruby.html)

Vitaly Pushkar goes over error handling in programming languages and the reasoning for using monads for error handling. I've been experimenting with that at work record with very positive results -- albeit in a limited portion of our code.

There is a section where the author talks about the **"pyramid of doom"** -- much like the [dry-monads documentation](https://dry-rb.org/gems/dry-monads/1.3/do-notation/). The "do notation" is presented as a solution. Maybe it's my lack of familiarity with that notation, but I think that there is a simpler solution, which I call "railway oriented".

Pyramid of Doom:

```ruby
def call(fields)
  validate_fields(fields).bind do |fields|
    validate_email(fields['email']).bind do |email|
      find_user(fields['id']).bind do |user|
        update_user(user, {name: fields['name'], email: fields['email']}).bind do |user|
          send_email(user, :profile_updated).bind do |sent|
            Success(user)
          end
        end
      end
    end
  end
end
```

Do notation:

```ruby
def call(fields)
  fields = yield validate_fields(fields)
  email = yield validate_email(fields['email'])
  user = yield find_user(fields['id'])
  user = yield update_user(user, {name: fields['name'], email: fields['email']})
  sent = yield send_email(user, :profile_updated)

  Success(user)
end
```

Note that the `yield` in the above solution differs from the standard Ruby meaning. It doesn't yield to the block passed to `#call` but rather binds the Result and halts execution of the method on failures.

My "railway oriented" solution:

```ruby
def call(fields)
  validate_fields(fields).
    bind { |fields| validate_email(fields['email']) }.
    bind { |_email| find_user(fields['id']) }.
    bind { |user| update_user(user, {name: fields['name'], email: fields['email']}) }.
    bind { |user| send_email(user, :profile_updated) }
end
```

The "pyramid of doom" is avoided, without having to change the Ruby semantics.

### [How to stop procrastinating by using the Fogg Behavior Model](https://www.deprocrastination.co/blog/how-to-stop-procrastinating-by-using-the-fogg-behavior-model)

The Fogg Behavior Model is a new concept for me. It presents a mental model in which:

```
Behaviour = Motivation + Ability + Trigger
```

A lack in any of the three factors can prevent behavior from occurring. The articles then talks about different strategies to boost each factor. For example, blocking time in your calendar can serve as a trigger to start working on a particular task. I've been very successful with that technique lately.
