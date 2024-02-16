---
layout: post
title: "Pipelines With Result Objects"
date: 2024-02-16 08:49:43 -0800
categories:
- ruby
excerpt_separator: <!-- more -->
---

In a previous post -- [On Class Structure][class_structure] -- we discussed how to organize Ruby classes so that the logic is not buried in private methods, and instead is clear to readers what the class is responsible for doing. In this post, I want to expand on that a bit more and introduce result objects.

Let's resume with our example:

```ruby
class FindScore
  DEFAULT_SCORE = 0
  URL = 'http://example.com'.freeze

  def initialize(user, http_client = HTTParty)
    @user = user
    @http_client = http_client
  end

  def call
    make_api_request(@user, @http_client)
      .then { parse_response(_1) }
      .then { extract_score(_1) }
  end

  private

  def make_api_request(user, http_client = @http_client, url = URL)
    http_client.post(
      url,
      body: { user: user.id }
    )
  end

  def parse_response(response)
    JSON.parse(response.body)
  end

  def extract_score(response_body, default = DEFAULT_SCORE)
    response_body.fetch("score", default)
  end
end
```

That class doesn't handle any errors. Each of the private methods can fail in different ways. For the sake of examples, lets say that we can encounter HTTP errors in `make_api_request`, the response may fail to be valid JSON or the response might have a different JSON shape than what we expect. One way to handle them is via exceptions or checking for specific conditions, and then ensuring that the value passed along is what the next step in our pipeline expects:

```ruby
class FindScore
  DEFAULT_SCORE = 0
  URL = 'http://example.com'.freeze

  def initialize(user, http_client = HTTParty)
    @user = user
    @http_client = http_client
  end

  def call
    make_api_request(@user, @http_client)
      .then { parse_response(_1) }
      .then { extract_score(_1) }
  end

  private

  def make_api_request(user, http_client = @http_client, url = URL)
    response = http_client.post(
      url,
      body: { user: user.id }
    )

    response.ok? ? response.body : "{}"
  end

  def parse_response(response)
    JSON.parse(response.body)
  rescue JSON::ParserError
    {}
  end

  def extract_score(response_body, default = DEFAULT_SCORE)
    response_body.fetch("score", default)
  end
end
```

In that version, `#make_api_request` checks for a correct response, passing the response body to `#parse_response`. If the response is not successful however, it returns `"{}"`, which is JSON that will be parsable by that response. In a similar manner, parsing JSON might raise `JSON::ParseError`. `#parse_response` rescues the exception, and returns a hash, as expected by `#extract_score`.

The code is now more resilient: It can handle some errors and recover from them by returning a value that can be used in the next method. However, these errors are being swallowed. What if we wanted to add some logging or metrics for each error, so we can understand our system better? One way, is to add a logging statement on the error branch of each method. I prefer another way, using result objects.

For our purposes a result object can either be a success or an error. In either case, it wraps another value, and it has some methods that act differently in each case. This object is known as a result [monad][monad], but let's now dwell on that. Our result object will make it easier to write pipelines of method calls, without sacrificing error handling.

A very minimal implementation looks like this:

```ruby
class Ok
  def initialize(value)
    @value = value
  end

  def and_then
    yield @value
  end

  def value_or(_other)
    @value
  end
end

class Error
  def initialize(error)
    @error = error
  end

  def and_then
    self
  end

  def value_or
    yield @error
  end
end
```

The polymorphic interface for `Ok` and `Error` has two methods: `#and_then` which is used to pipeline operations, and `#value_or` which is used to unwrap the value. Let's see some examples:


```ruby
Ok.new(1)
  .and_then { |n| Ok.new(n * 2) } # => 1 * 2 = 2
  .and_then { |n| Ok.new(n + 1) } # => 2 + 1 = 3
  .value_or(:error)
# => 3

Ok.new(1)
  .and_then { |n| Ok.new(n * 2) } # => 1 * 2 = 3
  .and_then { |n| Error.new("something went wrong") }
  .and_then { |n| Ok.new(n + 1) } # => Never called
  .and_then { |n| raise "Hell" } # => Never called either
  .value_or { :error }
# => :error
```

A chain of `#and_then` calls continue much like `#then` does, expecting a result object as a return value. However, if the return value at any point is an `Error`, subsequent blocks will not execute, and instead will continue returning the same result object. We then have a powerful way of constructing pipelines. Error handling can be left to the end.

Our class with error handling, can now be written as:

```ruby
class FindScore
  DEFAULT_SCORE = 0
  URL = 'http://example.com'.freeze

  def initialize(user, http_client = HTTParty)
    @user = user
    @http_client = http_client
  end

  def call
    make_api_request(@user, @http_client)
      .and_then { parse_response(_1) }
      .and_then { extract_score(_1) }
      .value_or { |error_message|
        log.error "FindScore failed for #{@user}: #{error_message}"
        DEFAULT_SCORE
      }
  end

  private

  def make_api_request(user, http_client = @http_client, url = URL)
    response = http_client.post(
      url,
      body: { user: user.id }
    )

    response.ok? ? Ok.new(response.body) : Error.new("HTTP Status Code: #{response.status_code}")
  end

  def parse_response(body)
    Ok.new(JSON.parse(body))
  rescue JSON::ParserError => ex
    Error.new(ex.to_s)
  end

  def extract_score(parsed_json)
    score = parsed_json["score"]

    score.present? ? Ok.new(score) : Error.new("Score not found in response")
  end
end
```

Now, each method is responsible for returning either an `Ok` or and `Error`. The `#call` method is responsible for constructing the overall pipeline and handling the failure (i.e. returning a DEFAULT_SCORE), and with a single line, it also logs all errors.

This technique is quite powerful. The result objects are not limited to private class methods. Public methods can return them just as well. The `Ok` and `Error` implementation is quite minimal as a demonstration for this post. There are full-featured libraries out there (e.g. [dry-rb](https://dry-rb.org/gems/dry-monads/1.3/)), or you can roll your own pretty easily and expand the API to suit your needs (e.g. `#ok?`, `#error?`, `#value!`, `#error`, `#fmap`).

As I concluded in my [previous post][class_structure], writing Ruby classes so that the class is read in the same order as the operations will be performed leads to more legible code. Adding result objects enhances those same goals, and makes error conditions a first-class concern.

[class_structure]: {% post_url 2023-09-24-on-class-structure %}
[monad]: https://en.wikipedia.org/wiki/Monad_(functional_programming)
