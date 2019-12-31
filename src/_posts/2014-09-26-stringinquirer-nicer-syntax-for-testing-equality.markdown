---
layout: post
title: "StringInquirer: Nicer Syntax For Testing Equality"
date: 2014-09-26 08:50
comments: true
categories:
- ruby
---

There is a well-known idiom in Rails, to tell wheather one is runnign in a specifc environment or not:

``` ruby
Rails.env.production? # => false
Rails.env.development? # => true
```

At first, it looks like `Rails.env` is a special kind of object that has methods defined on it to check for the environment properties. However, upon closer inspection, it looks like it is really just a `String`, but not quite:

``` ruby
>> Rails.env
=> "development"
>> Rails.env.class
=> ActiveSupport::StringInquirer
```

As the documentation says, `StringInquirer` is just a pretty way to test for equality. It can be used outside of Rails, say for example to be a bit lenient when reading environment variables:

``` ruby
require 'active_support/core_ext/string'

class Logger
  def log(message)
    message if verbose?
  end

  private

  def verbose?
    env_verbose.true? || env_verbose.yes?
  end

  def env_verbose
    @env_verbose ||= (ENV['VERBOSE'] ||= '').downcase.inquiry
  end
end

Logger.new.log("Hello, World") # => nil

ENV['VERBOSE'] = 'yes'
Logger.new.log("Hello, World") # => "Hello, World"

ENV['VERBOSE'] = 'YES'
Logger.new.log("Hello, World") # => "Hello, World"

ENV['VERBOSE'] = 'True'
Logger.new.log("Hello, World") # => "Hello, World"
```
