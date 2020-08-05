---
layout: post
title: "The REPL: Issue 70 - June 2020"
date: 2020-08-04 17:09:13 -0700
categories:
- the repl
excerpt_separator: <!-- more -->
---

### [Simple Made Easy](https://www.infoq.com/presentations/Simple-Made-Easy/)

This talk is not new, but it is new to me. I've seen reference to this talk in many places, but hadn't watched until recently.

> Rich Hickey emphasizes simplicity’s virtues over easiness’, showing that while many choose easiness they may end up with complexity, and the better way is to choose easiness along the simplicity path.

This is a fantastic talk! It describes how software that is simple is the ultimate goal. Simple is achievable, but it is not the same as easy. It goes hand-in-hand with choosing the correct abstractions and planning beforehand. It's not about hiding complexity, it's about abstracting it away. It reminds me of something that I distilled from somewhere else as:

An abstraction removes from your mental load. Indirection adds to it.

An abstraction lets you forget about the details and allows higher order thinking. Indirection forces you to think about the details constantly.

### [Result Objects - Errors Without Exceptions](https://www.rubypigeon.com/posts/result-objects-errors-without-exceptions/)

Tom Dalling of Ruby Pigeon introduces his library [Resonad](https://github.com/tomdalling/resonad). It aims at dealing with error handling without exceptions. The article gives a good overview why and when to use result objects. There are other libraries in the Ruby ecosystem (like [dry-monads](http://dry-rb.org/gems/dry-monads/)). As the author points out, it doesn't actually take a lot to build your own. I did so recently and was pleasantly surprised how far a very simple implementation can take you:

```ruby
class Failure
  attr_reader :error

  def initialize(error)
    @error = error
  end

  def successful?
    false
  end

  def failure?
    true
  end

  def and_then
    self
  end
end

class Success
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def successful?
    true
  end

  def failure?
    false
  end

  def and_then
    yield(value)
  end
end

Success.
  new(1).
  and_then { |v| Success.new(1 + 1) }.
  and_then { |v| Failure.new(:boom) }.
  and_then { |v| Success.new(1 + 1) }
# => #<Failure:0x00007f9eda02f280 @error=:boom>
```

At work, I am evaluating the usage of result monads as part of some work to better encapsulate domain logic. I am expecting it will be very beneficial in how we handle errors.
