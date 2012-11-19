---
layout: post
title: "Lambdas are Picky: ArgumentError in ruby 1.9"
date: 2012-11-07 17:01
comments: true
categories:
- ruby
---

## TL:D R;

In ruby > 1.9 lambdas are picky about arguments passed when calling and will raise ```ArgumentError```. Procs, will
pass ```nil``` as the argument values.

<!-- more -->

## Lambda behave differently in ruby 1.8 and 1.9

 While preparing a project to work with ruby 1.9.3, I came across a problem that was very hard to debug, because it
 manifested itself inside DataMapper, which I am not that familiar with. In addition, since the nature of lambda is
 code that will get run later, the problem manifested itself far away from where it was introduced. In any case, it can
 be illustrated like this:

{% codeblock lang:ruby %}
# ruby 1.8
>> l = lambda { 'Hello World!' }
=> #<Proc:0x0000000106db80d8@(irb):8>
>> l.call
=> "Hello World!"
>> l.call('a')
=> "Hello World!"
{% endcodeblock %}

In ruby 1.9 on the other hand, we get:

{% codeblock lang:ruby %}
# ruby 1.9
>> l = lambda { 'Hello World!' }
=> #<Proc:0x007f8fa4edba80@(irb):10 (lambda)>
>> l.call
=> "Hello World!"
>> l.call('a')
ArgumentError: wrong number of arguments (1 for 0)
	from (irb):10:in `block in irb_binding'
	from (irb):12:in `call'
	from (irb):12
	from /Users/ylansegal/.rvm/rubies/ruby-1.9.3-p286/bin/irb:16:in `<main>'
{% endcodeblock %}

By design, the lambda's will complain if the number of arguments when defining is different than when calling. Procs,
it's close cousins, do not:

{% codeblock lang:ruby %}
# This works in both ruby 1.8 and 1.9
>> p = Proc.new { 'Hello World!' }
=> #<Proc:0x0000000106daf370@(irb):11>
>> p.call
=> "Hello World!"
>> p.call('a')
=> "Hello World!"
{% endcodeblock %}

In my particular case, the lambda was defining a default value for a DataMapper property. When calling, data mapper
checked if it quacked like a Proc (by using ```respond_to?(:call)```) and proceeded to call with two arguments: The
resource and the property. To make it work, I could either define the lamda with two arguments (which I was not doing) or
use Proc.new instead. I ended up going with Proc.new.
