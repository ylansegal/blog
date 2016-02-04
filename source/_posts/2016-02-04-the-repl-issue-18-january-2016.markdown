---
layout: post
title: "The REPL: Issue 18 - January 2016"
date: 2016-02-04 08:34:05 -0800
comments: true
categories:
- the_repl
---

### [Getting to Zero Exceptions][1]

The folks at Yeller, propose a simple but powerful idea: Don't tolerate any exceptions in production applications. Having a constant stream of exceptions that don't really expose something that needs to be fixed causes intolerable noise that erodes confidence in the applications and obscures actual problems. I've had projects in the past where this was the rule and loved it. Constant discipline is the key to success.

### [When to choose Elixir over Ruby for 2016 projects?][2]

Elixir seems to be picking up speed and in this post Hubert Łępicki @ AmbertBit explains when he thinks Elixir is a better option than Rails. And no, the answer is not always.

### [The Rails Doctrine][3]

David Heinemeier Hansson, Rails' [BDFL][4], has written a post on what the philosophy behind Rails is. The content of the post is really interesting and elaborates on his vision of Rails and why it has been successful. It is a clear statement of the values that are important to him. For example, he clearly states that he doesn't really care about being a purist of any paradigm, like object orientation or MVC, but instead is guided by pragmatism. I recommend Rails and Ruby developers read the post. It's possible that you don't agree with all the stated values, but I think it's a good thing for them to be stated so plainly and clearly. Expectations on all sides are more likely to be met.

Regarding the delivery: DHH at times has been a polarizing person in the community. His manner can be very grating to some. This post also has some of that, starting with the title. Even though the dictionary definition of `doctrine` is used correctly, in common speech it is usually reserved for religious teachings or tenets of political movements. Used for the principles behind a web-framework (even one that I love and use every day) seems self-aggrandizing. It is easy for me to see past that and take it for a grain of salt, but I know that for some, it can be extremely off-putting.

[1]: http://yellerapp.com/posts/2015-06-01-getting-to-exception-zero.html
[2]: https://www.amberbit.com/blog/2015/12/22/when-choose-elixir-over-ruby-for-2016-projects/
[3]: http://rubyonrails.org/doctrine/
[4]: https://en.wikipedia.org/wiki/Benevolent_dictator_for_life
