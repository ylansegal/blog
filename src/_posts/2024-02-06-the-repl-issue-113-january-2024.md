---
layout: post
title: "The REPL: Issue 113 - December 2024"
date: 2024-02-06 11:40:20 -0800
categories:
- ruby
excerpt_separator: <!-- more -->
---

### [Tech Companies Are Irrational Pop Cultures][pop]

I agree with the author that there is a lot of Pop Culture in software companies, in the sense that they forget about the past, and there is a bias for "newer is better". Thus, we get [all the articles][boring] advising to choose "boring" technology with a proven track record.

There also does seem to be a good amount of contagion in the current round of layoffs. Companies are firing people, even if that they are doing well. I disagree that it is irrational. I dislike that characterization. It seems like a crutch for failing to understand the motivation for the people making the decisions. I believe that company executives *do* know that layoffs are bad for morale and create some problems down the line. There are some pretty smart people in company management. I think that they are making those decisions *in spite* of knowing that there are real downsides. Maybe the pressure from boards or investors is too much. Even if it is a case of copying what others are doing, it need not be irrational. There is an incentive to go with the flow: It's safe. [No one ever got fired for buying IBM][IBM]. If things go wrong, you wont be blamed for making the same decision everyone else made.

### [Anti-Pattern: Iteratively Building a Collection ][collections]

Mike Burns writes about how iteratively building a collection is an anti-pattern:

> What follows are some lengthy method definitions followed by rewrites that are not only more concise but also more clear in their intentions.

It resonates with me that the pattern should be avoided. Brevity and clarity are great, but I think minimize mutation is a better reason to avoid building collections iteratively. Written in a functional style, your code handles less mutation of data structures, which means that it handles less state. Handling state is were a lot of complexity hides, and the source of many bugs. In fact, in [Joe Armstrong][joe]'s estimation:

> State is the root of all evil. In particular functions with side effects should be avoided.

The style of Ruby that the article encourages removes the state handling from your code. 👍🏻

### Is It Possible for My Internet Router to Wear Out?

Every few years, my routes start acting up in strange ways. Some devices function great, while others seem to have intermittent downloads. This articles confirms my suspicions. Router just wear out:

> In general, routers can and do fail. The primary cause of failure for consumer grade equipment is heat stress. Most consumer grade hardware runs far too hot and have respectively poor air circulation compared to their ventilation needs.

To increase ventilation, I've started raising my router from the surface it's on with a Lego structure that increases airflow from the bottom. It seems to improve heat dissipation by the imprecise measure of "it feels cooler to my touch". 🤷🏻‍♂️

[pop]: https://softwarecrisis.dev/letters/tech-is-a-pop-culture/
[IBM]: https://www.origina.com/blog/nobody-ever-got-fired-for-buying-ibm
[boring]: https://duckduckgo.com/?t=ffab&q=use+boring+technology&ia=web
[collections]: https://thoughtbot.com/blog/iteration-as-an-anti-pattern
[joe]: http://harmful.cat-v.org/software/OO_programming/why_oo_sucks
[router]: https://www.howtogeek.com/125747/is-it-possible-for-my-router-to-wear-out/
---
