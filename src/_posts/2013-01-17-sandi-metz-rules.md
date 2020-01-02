---
layout: post
title: "Sandi Metz' Rules"
date: 2013-01-17 12:19
comments: true
categories:
- design
---

Sandi Metz recently was a guest at a [Ruby Rouges Podcast][1] to discuss her book [Practical Object Oriented Design In Ruby][2], which I reviewed. I encourage you to [listen to the episode][3].

During the interview, she mentioned some rules that she had come up with to give when asked about design guidelines. She was clear that the rules could be broken, but once you understand why the rules are there in the first place.

Without further ado:

1. Your class can be no longer than 100 lines of code
2. Your methods can be no longer than 5 lines of code
3. You can pass no more than 4 parameters, and you can't just make it one big hash
4. Your controller can only instantiate 1 object to do what needs to be done
5. Your view can only know about 1 instance variable

<!-- more -->

Rules 1, 2 and 3 seems like the least revolutionary. Code is easier to understand in smaller pieces, and these rules encourage the programmer to stick to them. While working on new code, I find these to be easy to stick to, but of course once you have a 500 line model, it's not very easy to refactor into smaller chunks.

Rule 5 is interesting. The current app I am working a JSON API, and for the most part, view rendering means initializing a decorator and calling a method to convert to JSON. However, on my last app, which did render HTML templates, this rule was broken on almost all views. I can certainly see the value on using some decorators or presenters to encapsulate some instance variables would be beneficial, for easier testing and simplified templates.

Rule 4, is the honey-pot. There are many cases where a controller action needs to interact with multiple domain objects. The rules states we can only instantiate one. So in order to follow the rule, it would be necessary to introduce intermediate objects that know about this interaction, effectively creating a service layer. This layer is inherently decoupled from the controller logic. *Brilliant*.

I'll try to stick to all the rules for a while longer and evaluate after.

[1]: http://rubyrogues.com/
[2]: http://www.poodr.info/
[3]: http://rubyrogues.com/087-rr-book-clubpractical-object-oriented-design-in-ruby-with-sandi-metz/