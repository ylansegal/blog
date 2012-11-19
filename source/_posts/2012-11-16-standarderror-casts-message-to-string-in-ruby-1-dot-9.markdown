---
layout: post
title: "StandardError casts message to string in Ruby 1.9"
date: 2012-11-16 17:27
comments: true
categories:
- ruby
---

When passing a message to StandardError in ruby 1.8, it will keep that object intact. Ruby 1.9 will convert to a String.
Spent more time than I wanted to chasing this down.

In ruby 1.8.7:

{% codeblock lang:ruby %}
>> RUBY_VERSION
=> "1.8.7"
>> err = StandardError.new(Object.new)
=> #<StandardError: #<StandardError:0x78952527>>
>> err.message.class
=> Object
{% endcodeblock %}

In ruby 1.9.3:

{% codeblock lang:ruby %}
>> RUBY_VERSION
=> "1.9.3"
>> err = StandardError.new(Object.new)
=> #<StandardError: #<Object:0x456c5f50>>
>> err.message.class
=> String
{% endcodeblock %}