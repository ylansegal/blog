---
layout: post
title: The Backlog Is Infinite
date: 2026-08-22 13:47:24.000000000 -07:00
categories:
- machine_learning
- productivity
excerpt_separator: "<!-- more -->"
syndication_excerpt: A friend who doesn't write software built an app with Claude
  Code, then asked if my company will fire half my team. I'm not worried. Our backlog
  has never once run dry.
syndicated:
- platform: bluesky
  url: https://bsky.app/profile/ylan.segal-family.com/post/3mtp766hej42y
  date: '2026-08-22 14:17:37 -0700'
---

A friend asked me if my company is going to fire half of my team. He doesn't write software. A few weeks earlier he had installed [Claude Code][claude-code], described an app he wanted, and got one. More or less. If he can do that knowing no programming at all, what does a company need a whole team of engineers for?

I get some version of this question regularly now, almost always from friends outside of software. I'm not worried. But not for the reason they expect.

<!-- more -->

The arithmetic is simple enough. Say we have a team of ten engineers, and AI makes each of them twice as productive. They now do the work of twenty. Fire five, keep the output you had before, save five salaries. That "twice as productive" is doing a lot of work, and I don't take it as a given. Let's assume it's true anyway.

The reasoning makes sense if engineering is a cost center.

If software is something the company buys to keep the lights on -- the internal tools, the reporting, the integration nobody outside the building will ever see -- then it's overhead. There's a fixed amount of it you need, and every dollar you don't spend on it is a dollar you keep. If each electrician can now keep twice as many lights on, you need half as many electricians. That isn't a foolish manager talking. That's just what a cost center is.

I have no doubt that some managers are running exactly this calculation right now, and that some of them are right.

Then there are the other companies, the ones that sell what engineering produces.

Same payroll, more output, more product to sell. You don't lay off half of a factory line that's running at a profit. You run it harder. A company that fires five of ten profitable engineers to save the salaries has voluntarily halved something that makes money.

The test isn't quite "does the company sell software," though. It's much broader in practice: *does better software sell more of what we already sell?* A company shipping hardware with software inside passes -- better software moves more boxes. So does the retailer whose app is how people actually buy things, and the bank where the deposits arrive through a phone. Stated that way, the number of engineering teams that are pure overhead is a lot smaller than my friends imagine.

What actually convinces me isn't the economics. It's what sprint planning looks like. So, to my friend's chagrin, that's what I explain.

My team has a backlog. For practical purposes, it is infinite. There is never a shortage of things to do: features customers want, bugs we know about, optimizations we keep meaning to get to, improvements we've been talking about for a year. Every sprint we sort by what would bring the most value, estimate how much we can actually finish, and draw a line.

If we overestimate, work spills over. It's usually at the top of the next sprint, though not always -- priorities move. If we underestimate, we have room left, and we pull in the next thing below the line. Notice what it doesn't have: a state where we run out of work. I have never seen that list run dry.

AI did change real things. Projects that weren't worth their cost before are worth it now, so there's appetite for more ambitious work. More tasks fit in a sprint. We may be shipping fewer bugs, because our review process is more thorough than it used to be.

What didn't change is the line. We still draw it every sprint, and there is still more below it than we can get to.

Which brings me back to the app my friend built.

He thinks he demonstrated that engineers are optional. What he actually demonstrated is that there was software worth building that nobody was building, because at the old price it wasn't worth anyone's time. Now it is, so he built it himself. Multiply that by everyone with an idea and no budget, and demand for software went up, not down.[^1]

There's an honest limit to this. It covers companies where software sells something, which is most of them, but not all. If you're on the internal tools team at a company whose product has nothing to do with software, none of my reasoning protects you, and I don't have a comforting version of this post for you.

For the rest of us, the backlog is infinite, the work above the line is worth more than it costs, and getting more of it for the same money is a good trade for everyone involved.

So no, I am not worried. I hope I'm right.

[^1]: Economists have a name for this shape: the [Jevons paradox][jevons]. In 1865 Jevons noticed that Watt's far more efficient steam engine did not reduce Britain's coal consumption. It increased it, because cheaper coal-power made coal worth burning in places it had never been worth burning before. I'm borrowing the shape of the argument, not claiming the result. Coal is a fuel and engineers are not, and whether the rebound in demand for software outruns the efficiency gain is a genuinely open question.

[claude-code]: https://claude.com/product/claude-code
[jevons]: https://en.wikipedia.org/wiki/Jevons_paradox
