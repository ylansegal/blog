---
layout: post
title: "The REPL: Issue 7 - February 2015"
date: 2015-03-02 19:54:14 -0800
comments: true
categories:
- the repl
---

### [Introducing Discrete Integration][1]

Gustave Dutra at Plataformatec, discusses a concept called Discrete Integration. The process described is very similar to what I use at work at the moment. A sort of dialed-back version of Continuous Integration. It reaps a lot of the benefits of rapid feedback, just not as extreme. Feature branches are worked-on until they are at a stable state before merging into master. Good developer communications is encouraged at all stages.

### [Require Only What You Require][2]

Janko Marohnić presents a well-thought out argument against requiring all code in gems up-front. His concerns are around what this communicates to other developers. The intention of each file or library required is lost as are the dependencies of each individual class. Finally, it makes it harder to clean-up dependencies once the are no longer used. I intend to adopt this style in the next gem I work on. I have actually done a similar thing in some Rails project, with a smaller scope: For example, if a class uses an external service wrapper, I require it on the top of the class even though it's already required by bundler, as a notice to other developers on the project.

### [Programming Is Not A Craft][3]

I [previously wrote][5] about my thoughts on the Software Craftsmanship metaphor. My main objection to the metaphor is that it evokes imagery that is not helpful to software development and completely unnecessary. In this article Dan North's tells us that the risk behind the craftsmanship movement lies in putting software ahead of the benefits it provides. My understanding is that so called 'craftsmen' pride themselves in delivering value first, but the article did provoke in my a deep sense that there is a lot of navel-gazing going on. Let's just focus on professionalism and excellence. Keep calm and code on.

### [Mark Methods Private When You Don't Test Them][4]

In his usual clear way Pat Shaughnessy writes about when to mark methods as private. Essentially, methods that have tests are part of what is considered the public API of the object. Untested methods and those that are private are not. Ruby performs the most basically check against calling private methods, that can be easily circumvented by using `send`. However, marking methods as private is more about communicating to other developers what part is internal to the class and should not be relied upon. This is very much in vein with [Sandi Metz take on testing][6]

[1]: http://blog.plataformatec.com.br/2015/02/introducing-discrete-integration/
[2]: https://twin.github.io/require-only-what-you-require/
[3]: http://dannorth.net/2011/01/11/programming-is-not-a-craft/
[4]: http://patshaughnessy.net/2015/2/16/mark-methods-private-when-you-dont-test-them
[5]: /blog/2015/02/24/book-review-the-software-craftsman/
[6]: https://speakerdeck.com/skmetz/magic-tricks-of-testing-railsconf
