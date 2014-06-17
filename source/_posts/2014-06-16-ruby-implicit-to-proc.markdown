---
layout: post
title: "Ruby Implicit `to_proc`"
date: 2014-06-16 20:08
comments: true
categories:
- ruby
---

Ruby's blocks are one of the language features I like the most. The make iterating on collections extremely easy.

``` ruby
[1, 2, 3].map { |n| n.to_s }
=> ["1", "2", "3"]
```

You can shorten the (already short!) syntax above, like so:

``` ruby
[1, 2, 3].map &:to_s
=> ["1", "2", "3"]
```

The above is implicitly calling `to_proc` on the symbol. This es extremely handy, when you are calling the same method
on each object. However, it can also be useful to call a method with each object as an _argument_:

``` ruby
def fancy_formatvalue)
 "==::[[#{value}]]::=="
end

['1', '3', 'a'].map &method(:fancy_format)

=> ["==::[[1]]::==", "==::[[3]]::==", "==::[[a]]::=="]
```

In addition, note that the number of arguments yielded to the method, depends on what the original implementation is. For hashes, this is especially useful:

``` ruby
def fancy_format(key, value)
  puts "==::[[#{key} - #{value}]]::=="
end

ball = { color: 'red', size: 'large', type: 'bouncy' }


>> ball.each &method(:fancy_format)
==::[[color - red]]::==
==::[[size - large]]::==
==::[[type - bouncy]]::==
```
