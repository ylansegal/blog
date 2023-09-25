---
layout: post
title: "On Class Structure"
date: 2023-09-24 17:38:37 -0700
categories:
- design
- ruby
excerpt_separator: <!-- more -->
---

Don't let short methods obscure a class's purpose.

There is a pattern of writing Ruby classes that I see a lot: Classes with small methods, most of them `private`. For example:

```ruby
class FindScore
  DEFAULT_SCORE = 0
  URL = 'http://example.com'.freeze

  def initialize(user)
    @user = user
  end

  def call
    score
  end

  private

  def score
    response_body.fetch("score", DEFAULT_SCORE)
  end

  def response_body
    @response_body ||= JSON.parse(response.body)
  end

  def response
    HTTParty.post(
      URL,
      body: { user_id: @user.id }
    )
  end
end
```

Each method is small, and easy to understand on it's own. However, I find that this code obscures the class's purpose. Figuring out what `FindScore` does feels like reading backwards, like solving a mystery. I see that `call` returns the score... which is extracted from the response body with a default if it wasn't there... the response body is memoized and is obtained from the response, and is parsed from JSON... the response itself obtained by making a web request. Now I can unravel the mystery: We are making a web request to obtain a user's score, it returns JSON which we parse, and the we extract the score from that. The sequence of operations are the reverse of how the code is written.

Notice how as I built up my mental image of what the class is doing, I was also dealing with the low-level details like the default score value, or memoization. And this is a fairly simple class.

For the last few years, I've been writing classes in a different style:

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

Let's ask the same question: What does `FindScore` do? It makes an API request, then it parses that response, then it extracts the score. That is it! That is the high-level overview of the class, all clearly laid out in `#call`. Now, I can deal with the details of each method if I am interested in knowing more.

Notice that the private methods are as small as in the first class: The are one liners. The major difference is in how we sequenced those methods. That makes a huge difference. We are now telling the story of this class at a high-level of abstraction. Additionally, the private methods in the class interact only with their arguments (and the constants in the class). That makes the methods easier to reason about. I've also decided to inject `http_client` in the initializer. It makes it clear which collaborators this class is dealing with: A `user` and an `http_client`. It gives an initial hint to the reader what is to come. I expect most callers will use the default, but injecting all collaborators makes it easier to test too.

---

Let's imagine that we decide that we need to cache the score instead of making a web request every time. In the first style, we would probably add caching like this:

```ruby
def score
  Cache.fetch("score-for-#{@user.id}") do
    response_body.fetch("score", DEFAULT_SCORE)
  end
end
```

It's expedient, but the fact that the score is cached is now again hidden in a private method.

In my alternate version, we can make it a part of the story:

```ruby
def initialize(user, http_client = HTTParty, cache_client = Cache)
    @user = user
    @http_client = http_client
    @cache_client = cache_client
  end

def call
  cache(@cache_client, @user) do
    make_api_request(@user)
      .then { parse_response(_1) }
      .then { extract_score(_1) }
  end
end

private

def cache(cache_client, user, &block)
  cache_client.fetch("score-for-#{@user.id}", &block)
end
```

I've added a few more lines than in the first implementation, in order to keep the story that is being told front and center, keeping the details at a lower-level of abstraction.

I've come to believe that this story-telling procedural way of classes is more legible and digestible by readers. It is organized in the same way and order that the sequence of operations it's codifying. It reminds me a lot about unix pipes.

**Don't let short methods obscure a class's purpose**. Inject your collaborators. Write method calls in the same order as the operations they are performing.
