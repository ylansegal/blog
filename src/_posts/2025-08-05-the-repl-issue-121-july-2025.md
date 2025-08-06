---
layout: post
title: "The REPL: Issue 129 - May 2025"
date: 2025-08-05 17:20:21 -0700
categories:
- machine_learning
- ruby
- zsh
excerpt_separator: <!-- more -->
---

### [I'm sold. Agentic coding is the future of web application development][sold]

Nate Berkopec has been writing about agentic coding as a game changer. I've been experimenting myself and can absolutely relate to his attitude. I can also relate to folks that have tried and are still skeptical. In my experience -- and it's short like everyone else's, because this is moving so fast -- both the agent and the model make a huge difference. Just the other day, I was doing something on my personal computer with the same agent I've been using at work but a different model. The results were much worse. So much so that I wound up just doing the work without the agent's help, even though I was very confident that the model available at work would have done correctly in seconds. And both models are the flagship of their respective companies. That is why I can see some people haven't had the light-bulb moment, and some have.

### [Speeding Up My ZSH Shell][zsh]

Scott Spence provides a guide on how to speed up your zsh prompt. My prompt is already very fast, having gone through some optimization a few months ago. If you haven't done this lately, I recommended. Having a fast zsh startup and prompt is a quality-of-life improvement.

### [Stop concatenating URLs with strings][urls]

I am glad Szymon Fiedler wrote this! I point this out in code review all the time. Now I have an article to point to.

If you are using active support (like Rails does), the query generation can be made easier with `#to_query`:

```ruby
require "active_support/all"

query_params = { format: "json", include: "profile" }
URI.encode_www_form(query_params)
# => "format=json&include=profile"

query_params.to_query
# => "format=json&include=profile"
```

[sold]: https://bsky.app/profile/nateberkopec.bsky.social/post/3ltzswz5eob2x
[zsh]: https://scottspence.com/posts/speeding-up-my-zsh-shell
[urls]: https://blog.arkency.com/stop-concatenating-urls-with-strings/
