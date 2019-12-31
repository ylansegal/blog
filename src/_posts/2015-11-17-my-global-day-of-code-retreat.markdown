---
layout: post
title: "My Global Day of Code Retreat"
date: 2015-11-17 11:19:06 -0800
comments: true
categories:
- design
- tdd
---

Last Saturday (11/14/2015) I attended my first code retreat, hosted by the kind folks at [Pluralsight][1]. The event was part of the [Global Day of Code Retreat][2]. 144 cities participated in the event, and for the first time San Diego was one of them.

> Global Day of Code Retreat: A day to celebrate passion and software craftsmanship

The retreat is a one-day exercise in honing the craft of programming. It started with a short introduction and then we were asked to pair with someone for the first exercise: [Conway's Game Of Life][3]. The exercise is specifically chosen because the domain is simple enough to understand within a couple of minutes, by implementing it is usually not trivial. We were not given any rules, except to use Test-Drive Development (TDD) throughout the day. Language choice and design was left up to each pair. After 45 minutes, we switched pairs and *deleted* our code. That is right: We deleted our code.

Why delete the code? Because the exercises are about learning, not about shipping working code. It's supposed to be in contrast to what we do at work every day, where we create artifacts that are production ready and ship them.

For each rotation, there was usually some extra restriction added or removed. The day was very intense and interesting. I paired with a Cobol programmer, with no TDD experience, looking to come back to programming after a hiatus. A .NET code school student, and another very experienced .NET developer. In a mob-programming session, we tried starting a project in Javascript, then Java and failed in each case because we didn't know how to get the test framework setup and ended up switching to Ruby, mainly because I know how to start a project with TDD baked in (`bundle gem game_of_life`). I had a chance to pair with an experienced javascript programmer, that was interested in ruby and with a gentleman that was an expert in both TDD and .NET. It was great seeing different approaches to the same problem come up. For example, I assumed that all solutions would require some sort of data structure to keep track of the state of each cell in each generation. However, several different people suggested using a set, to only keep track of live cell. Those solutions ended up being very elegant.

In each exercise, I learned something interesting. I learned that it's easy to take for granted the shared understanding and context that you have with your team around what "clean" code looks like, what to test, how to structure test and even what type of tests there are (ie. unit, functional, integration, etc). I learned that there are many people that are just now getting acquainted with TDD and extreme programming. I learned that pair programming forces you to be explicit about what you are doing and be convincing about the path forward, since you pair needs to agree. I learned that if you are willing to listen, you can learn new things from everyone and anyone.

[1]: https://www.pluralsight.com
[2]: http://gdcr.coderetreat.org/
[3]: https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
