---
layout: post
title: "Don't Rescue RuntimeError"
date: 2019-01-18 12:02:37 -0800
comments: true
categories:
- ruby
---

I came across some code recently that attempted a long series of steps, and on failure issued a notification. Something functionally similar to:

```ruby

def complicated_method
  # Several calls to things that can raise
rescue RuntimeError => ex
  notify_failure(ex)
end
```

At first instance, this seems appropriate. After all, Ruby defaults to raising a `RuntimeError` when not using a more specific exception:

```ruby
def boom!
  raise "Hell"
rescue => ex
  ex
end

boom! # => #<RuntimeError: Hell>
```

There is a subtlety here: Ruby default to raising a `RuntimeError`, but defaults to rescuing a `StandardError`. A `RuntimeError` has a `StandardError` as an ancestor, which means that any `RuntimeError` will be rescued from a "naked" raise. However, when we specify `RuntimeError` as the rescue clause, we might miss a lot of exceptions that we *thought* we were rescuing, because they don't have `RuntimeError` as an ancestor.

```ruby
RuntimeError.ancestors # => [RuntimeError, StandardError, Exception, Object, Kernel, BasicObject]
ArgumentError.is_a?(RuntimeError) # => false
IOError.is_a?(RuntimeError) # => false
TypeError.is_a?(RuntimeError) # => false
```

## Conclusion

When possible, always rescue specific exceptions, to avoid supressing exception. Failing that, rescue `StandardError`, not `RuntimeError`. Oh, and [don't rescue `Exception`][thoughbot].

[thoughbot]: https://robots.thoughtbot.com/rescue-standarderror-not-exception
