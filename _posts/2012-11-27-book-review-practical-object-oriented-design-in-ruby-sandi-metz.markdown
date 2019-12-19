---
layout: post
title: "Book Review: Practical Object-Oriented Design In Ruby - Sandi Metz"
date: 2012-11-27 15:52
comments: true
categories:
- books
- ruby
---

{% blockquote %}
If you call yourself a ruby programmer, you should read this book.
{% endblockquote %}

Sandi Metz has done a great job explaining how to write maintainable applications, in a way that is accessible to programmers
at any skill level. Her book is concise (less than 250 pages, including the index), but jam-packed with great nuggets
of practical advice and coding techniques that you can start applying immediately in your projects. Her style is easy
to read, with many code examples that show you the evolution of code, as an application changes and is refactored.

Among the techniques discussed:

* Use dependency injection to avoid coupling between objects. (Makes them easier to test too)
* To write great APIs, focus on the messages being sent between objects. (She shows why you would actually __want to__
use a UML diagram)
* By creating role tests and applying them to test doubles, you can avoid the 'leaving the dream' problem, where stubs in tests obscure the fact that objects interfaces have changed.

Links: [Publisher Site](http://www.informit.com/store/practical-object-oriented-design-in-ruby-an-agile-primer-9780321721334),
[Amazon.com](http://www.amazon.com/gp/product/0321721330)