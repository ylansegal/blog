---
layout: post
title: Sandi Metz' Revised Rules
date: 2013-12-11 14:44
comments: true
categories: 
- design
---

I [previously wrote][1] about [Sandi Metz][2]' proposed rules. I had the pleasure of hearing her talk about them last week at the monthly [SDRuby][3] meeting. 

It turns out that she misspoke in the original [Ruby Rogues Podcast Episode][4] and has since revised them to be:

+ No More Than:
    + 100 lines per class
    + 5 lines per method
    + 4 (or even better 3) parameters per method (each hash key counts)
    + 1 instance variable per view
    + 2 class names per controller (1 business object, 1 presentation object)

The main difference from the previous rules, as mentioned on the [podcast][4] is that each controller can know about *2* class names: This is pretty significant. I have been trying to adhere to the original rules for a long time. However, no matter how hard I tried, I could not get a controller action that just talked to 1 object, because that meant coupling the view to the business object, which just felt wrong. In the end, I just let it be and created a business object, which was later decorated by another object for the view. After hearing Sandi's revised rules, I feel vindicated!

This reminds me of the dispensation: **You can break any of the rules, as long as someone else on the team agrees**.

{% blockquote Sandi Metz %}
Code draws code like it
{% endblockquote %}

I really enjoyed hearing Sandi talk. The SDRuby taping is not yet available, but it looks like Sandi gave the [same talk][5] elsewhere. 

[1]: /blog/2013/01/17/sandi-metz-rules/
[2]: http://www.sandimetz.com/
[3]: http://www.sdruby.org/
[4]: http://rubyrogues.com/087-rr-book-clubpractical-object-oriented-design-in-ruby-with-sandi-metz/
[5]: https://www.youtube.com/watch?v=npOGOmkxuio

