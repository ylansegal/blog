---
layout: post
title: "The REPL: Issue 13 - August 2015"
date: 2015-09-01 08:41:10 -0700
comments: true
categories:
- the repl
---

### [Making Architecture Matter][1]

In this keynote at OSCON 2015, Martin Fowler gives a great overview about how to think about software architecture to get the most benefit. As quoted in the comments:

{% blockquote %}
It’s particularly relevant now as we push more and more toward continuous delivery, continuous deployment, features updated over the Internet all the time. That degree of being able to respond to change becomes important. That’s the economic reason why software architecture is important, because if we don’t keep good architecture, we are, in the end, deceiving our customers — in fact, stealing from our customers — because we’re slowing down their ability to compete.
{% endblockquote %}

### [Binary pattern matching in Elixir][2]

Zohaib Rauf writes a great post that shows the great power of pattern matching in Elixir. Step by step, he builds a small module that parses PNG binaries. The explanations are clear and the resulting code is really elegant: One main function that parses the header and calls a private recursive function that parses each of the chunks. Worth a read, even if you are not into Elixir (yet!).

### [Work Hard, Live Well][3]

Dustin Moskovitz writes about work life balance in the software industry and his personal experience at Facebook. The article resonates with me: I often say that in the modern world, sleep is a competitive advantage: Being tired decreases cognitive ability. When I was a freshman in college, I stayed up late to study for a physics exam, which I presented after only 4 hours of sleep. I had flunked because of basic algebraic mistakes applying the correct physical formulae. I took the lesson to heart. After that, for me exam preparation always included adequate rest.

[1]: https://www.youtube.com/watch?v=DngAZyWMGR0
[2]: http://zohaib.me/binary-pattern-matching-in-elixir
[3]: https://medium.com/life-learning/work-hard-live-well-ead679cb506d
