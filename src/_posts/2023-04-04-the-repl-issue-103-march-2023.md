---
layout: post
title: "The REPL: Issue 103 - March 2023"
date: 2023-04-04 18:14:25 -0700
categories:
- machine_learning
- git
excerpt_separator: <!-- more -->
---

### [What Is ChatGPT Doing … and Why Does It Work?][Chatgpt]

*The* Stephan Wolfram explains what ChaptGPT is doing. This article is very technical and on the long side. I found it quite enlightening to learn about what LLM are doing. A [more accessible article][accesible] article can be found, but I hate it's name: "normie" is an objectionable term. It's condecending, like you are not "in on something".

### [I wish people would stop insisting that Git branches are nothing but refs][git]

The article covers the friction of the mental model of using git vs the actual implementation. I've read a ton of complaints about git's UX, the leaky abstraction, and all that. It's true: Using git without knowing some of the plumbing is hard and doesn't make much sense. In my experience, the more I've learned over the years from articles and especially from the [Building Git][building] Book, have made me much better at it, *because* I know understand the internals.

In any case, the author seems correct to me: Saying that branches are just refs, is not helpful. A branch is a moving ref, which implies a series of commits. That is how most people think and talk about branches.

[chatgpt]: https://writings.stephenwolfram.com/2023/02/what-is-chatgpt-doing-and-why-does-it-work/
[accesible]: https://www.jonstokes.com/p/chatgpt-explained-a-guide-for-normies
[git]: https://blog.plover.com/prog/git/branches.html
[building]: {% post_url 2020-05-18-book-review-building-git %}
