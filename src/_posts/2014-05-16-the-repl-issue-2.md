---
layout: post
title: "The REPL: Issue 2"
date: 2014-05-16 16:06
comments: true
categories:
- the rep
excerpt_separator: <!-- more -->
---

### [The Little Mocker][1]

[Uncle Bob writes][1] about mocks, stubs, doubles, spies, etc. He explains the differences between them, how and when to use them. The examples are in Java, but are easily followed even with vague familiarity with the languge.

### [Back To Basics: Regular Expressions][2]

The fellows at thoughbot give a [great primer on regular expressions][2] in ruby. The examples are easy to follow and yet manage to explain a lot of more advanced concepts like capture groups, expression modifiers and lookarounds.

### [Goto Fail, Heartbleed, and Unit Testing Culture][3]

Back when Apple's [Goto Fail bug][4] was news, my reaction to this was: How did the introduction of this bug pass the tests. At the time I thought about writing a test suite around it and running it with and without the duplicated line that causes the bug to demonstrate how test catch regression mistakes. I never got around to it, mainly because of my lack of familiarity with the language. Martin Fowler has written [a lengthy and thoughtful post][3] that expressess the feeling much better than I would have. It gives the same treatment to the [Heartbleed Bug] and explains why testing is so important in softare development.

I am lucky to work mainly in ruby, a community that is very test-oriented, even after the recent [hoopla][5].

[1]: http://blog.8thlight.com/uncle-bob/2014/05/14/TheLittleMocker.html
[2]: http://robots.thoughtbot.com/back-to-basics-regular-expressions
[3]: http://martinfowler.com/articles/testing-culture.html#heartbleed-how
[4]: https://www.imperialviolet.org/2014/02/22/applebug.html
[5]: http://david.heinemeierhansson.com/2014/test-induced-design-damage.html
