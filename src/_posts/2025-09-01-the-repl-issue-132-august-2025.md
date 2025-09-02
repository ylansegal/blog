---
layout: post
title: "The REPL: Issue 132 - August 2025"
date: 2025-09-01 18:26:06 -0700
categories:
- machine_learning
- ruby
excerpt_separator: <!-- more -->
---

### [Stop concatenating URLs with strings — Use proper tools instead](https://blog.arkency.com/stop-concatenating-urls-with-strings/)

I am glad someone wrote this. I point this out in code review all the time. Now I can send them this link.

If you are using `ActiveSupport` (e.g. On a Rails project), the query generation can be made easier with `#to_query`:

```ruby
require "active_support/all"

query_params = { format: "json", include: "profile" }
URI.encode_www_form(query_params)
# => "format=json&include=profile"

query_params.to_query
# => "format=json&include=profile"
```

## ["I'm sold. Agentic coding is the future of web application development](https://bsky.app/profile/nateberkopec.bsky.social/post/3ltzswz5eob2x)

Nate Berkopec is a smart guy, and he points out that agentic coding is a game changer. I feel it too. Once I started using Roo, it felt like there is no going back. I am still working out how to best work with it and improve it, learning how to prompt it and thinking about TDD. Overall, it has certainly been a boost, especially in architectural planning and coding; it's been very effective.

Some folks make it seem like we won't write *any* code anymore. I don't think that is true. I find myself tweaking nearly all of the agent's suggestions. However, it certainly feels like a big shift in *how* we code.

### [The New Skill in AI is Not Prompting, It's Context Engineering](https://www.philschmid.de/context-engineering)

The article resonates with my usage of AI: To get good answers, you need to give good context to the LLM. Tell it what to do, what files are relevant, and what parts of the code you expect it to touch. Very importantly, tell it what *not* to do in the task.
