---
layout: post
title: "Use AI Agents to Experiment"
date: 2025-08-17 10:36:49 -0700
categories:
- machine_learning
- fish_shell
excerpt_separator: <!-- more -->
---

I've come across mentions of [fish][fish], the shell, many times in chats and articles over the years. I've always been curious because I spend a lot of my time in the terminal.

Trying a new shell with the defaults is typically not a great experience. I know that is one of `fish`'s selling points—that the defaults are better than in other shells. And I don't doubt that. It's just not relevant to me. I've been schlepping my dotfiles between computers for almost 10 years. I don't use the default `zsh`. In any case, as [I've written before][productive], I use a few shortcuts extensively to find files and commits. They are essential to my workflow.

And so it has been that trying out a new shell seems like a lot of work: trying to learn first how to customize it to make myself somewhat productive, while I figure out if I really like it or not. It has always seemed like a large up-front investment.

Last weekend, I figured: What if I ask my AI agent to port my `zsh` configuration to `fish`? It handled it without a problem. In a few minutes, I had a fish configuration that was so similar to my `zsh` configuration that I was getting confused as to which shell I was in. I added a <span class="emoji">🐟</span> to my prompt as a reminder.

Of course, if everything was identical, then I am not really using `fish`. I then had a bit of a chat with the agent: With the context of what I typically do in the command line, my past experience, and what I've already customized. It gave me a few suggestions for what parts of `fish` I would get more mileage out of.

The results were so good that I was able to work in `fish` the whole week, with only very minor issues. A few times I reverted to `zsh`, but mostly to find a command in the history that I didn't want to figure out from scratch[^1].

I am still not convinced that I am going to be using `fish` going forward. The point is that using an AI agent lowered the cost of *trying* to use `fish` so much that I am now able to experiment. What other things can AI help me experiment with?

[fish]: https://fishshell.com
[productive]: {% post_url 2025-03-16-how-im-productive-in-the-command-line %}
[^1]: That is probably an indication that I should add an alias or script for that command
