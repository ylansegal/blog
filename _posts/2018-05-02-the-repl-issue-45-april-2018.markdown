---
layout: post
title: "The REPL: Issue 45 - April 2018"
date: 2018-05-02 18:28:16 -0700
comments: true
categories:
- the repl
---

## [the Origins of Opera and the Future of Programming][opera]

Jessica Kerr writes eloquently about how some groups of people in music, painting, science, and programming produce extraordinary results, like the invention of a novel genre of music. She goes deep into the theory behind it and introduces the concept of *symmathesy*:

>  Nora Bateson points out that there’s more to a living system than parts and interrelations: the parts aren’t constant. We grow and learn within the system, so that the parts don’t stay the same and the interrelationships don’t stay the same. She gave a word to this, something deeper than any mechanical or model-able system, a learning system composed of learning parts: symmathesy.

I am still processing what this all means. My immediate takeaway is that some teams have dynamics in which positive outcomes are amplified to form a virtuous cycle. I believe this is equivalent to what people mean by "synergy".

## [How I Write SQL, Part 1: Naming Conventions][sql]

This post covers a lot of detail on the naming conventions Sehrope Sarkuni prefers when writing SQL, including the rationale behind for each convention. I agree with most of the conventions. In reality, I am more interested in my team [having conventions][conventions]  in the first place.

## [How To Index Your Database][index]

The slides for Baron Schwartz's presentation at PostgresConf US 2018 cover a lot of detail on what indexes are, how databases use them and in the uses cases where indexes help: Read less data, read data in bulk, and read data presorted. This is one of those slide decks that contains enough information and context without needing to see the talk -- not available on video at the time of writing.   

[opera]: https://the-composition.com/the-origins-of-opera-and-the-future-of-programming-bcdaf8fbe960
[sql]: https://launchbylunch.com/posts/2014/Feb/16/sql-naming-conventions/
[index]: https://www.xaprb.com/talks/index-postgresql-database-postgresconf-2018/
[conventions]:/blog/2016/12/22/enforcing-style/
