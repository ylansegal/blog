---
layout: post
title: "The REPL: Issue 105 - May 2023"
date: 2023-07-03 15:10:48 -0700
categories:
- machine learning
excerpt_separator: <!-- more -->
---

### [How First Principles Thinking Fails][1]

Thinking from first principles is not a silver bullet:

> When reasoning from first principles, you may fail if:

> You have flawed assumptions.

> You make a mistake in one of your inference steps. (An inference step is a step in the chain of reasoning in your argument).

> You start from the wrong set of principles/axioms/base facts.

> You reason upwards from the correct base, but end up at a ‘useless’ level of abstraction.

I've been thinking a lot about the third one. If you don't know certain facts, and you don't know that you don't know them, you can reach wrong conclusions.

For example, if you only know Newtonian physics, you will calculate the orbits of plants very precisely, but you will come to the wrong conclusions about Mercury's orbit. You need to know about Relativity to get that orbit correct.

In essence, the "unknown unknowns" can get you.

### [Speed matters: Why working quickly is more important than it seems][2]

If you are fast at something, of course you can do more of that thing in a given time. The author proposes that you also have a lower perceived cost for doing more of that thing, and that in itself lowers he barrier to doing more of that activity. The conclusion is that if you want to do more of something, you should try getting faster at it.

How do you get faster at something? In running (the sport), you get faster by doing speed-work, sprints, and the like. You also get faster by running longer and longer distances, at a relatively *slow* pace. The physiology is interesting, but not my point. In guitar playing, a very effective technique for learning a fast solo or transition is to use a metronome and *slow* down to practice the section, say at 50%, speed until your are proficient at it, then increase to 60% and so on, until you can play it at 100%.

While I agree that doing something faster promotes you doing more of it, it is not always intuitive *how* to get faster.

### [I’m an ER doctor. Here’s how I’m already using ChatGPT to help treat patients][3]

This resonates with me: In it's current form, ChatGPT is already very usable to generate text that you can verify is correct. In this example, the doctor can read the text and can tell if it's empathetic, like he requested, and correct. It saved him from having to type it, and in fact maybe even did something that he could not: Communicate with more empathy. In any case, the doctor was 100% capable of evaluating the text produced.

In my personal use of LLMs, they can and will suggest code snippets. It saves me the time of having to read API documentation of several classes. I can evaluate the result for correctness, and even more importantly, I will adapt for my use case which will include tests for formally verifying that the code indeed works as expected.

I am not sure about the drunken intern analogy: I probably would have phrased it as a sleep-deprived intern instead. The intern heuristic is useful though. Getting back to the my code usage: It is useful to think of LLMs as an intern that produces code very fast, but that I have to evaluate. "Hey intern, how do I add a custom header to a web request using Ruby's 'rest' gem?". I am capable of evaluating the result and making whatever corrections are needed. Time saved.

[1]: https://commoncog.com/how-first-principles-thinking-fails/
[2]: http://jsomers.net/blog/speed-matters
[3]: https://inflecthealth.medium.com/im-an-er-doctor-here-s-how-i-m-already-using-chatgpt-to-help-treat-patients-a023615c65b6
