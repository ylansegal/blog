---
layout: post
title: "The REPL: Issue 1"
date: 2014-03-07 20:03
comments: true
categories:
- the_repl
---

Today, I am starting a new feature for this blog. I am calling it The REPL. It's pretty much a link page of interesting reading I have done around the web in the last week (or, more than likely, since the last issue). Of course, this is not a new idea, but I still think there might be some value to it. I will try to avoid this becoming an [echo chamber][1] and instead I will try to focus on material that has got me thinking about software engineering.

# [The Circuit Breaker Pattern][2]

Martin Fowler explains the [circuit breaker pattern][2]. Coincidentally at work, we have been discussing using something like this for building in fault tolerance in our interactions with other services. [Netflix has a library][3] (in java) for this sort of thing and [has blogged][4] about it's use. Embracing that failure will happen and properly preparing for it turns how you design your code on its head.

# [Using Interactors To Clean Up Rails][5]

The [fellows at Grouper explain][5] how they are using the [interactor gem][6] to extract business logic from controllers and models. Again, this is a pattern that we adopted at work not too long ago. DHH gave it some flak on the [hacker news comments][7], but it has given our team a convention on where and how to code business logic.

# [Store Data Not Types][8]

[A cautionary tale][8] on why it's important to set clear boundaries between your system and the libraries and frameworks that you use.

[1]: https://en.wikipedia.org/wiki/Echo_chamber_(media)
[2]: http://martinfowler.com/bliki/CircuitBreaker.html
[3]: https://github.com/Netflix/Hystrix
[4]: http://techblog.netflix.com/2012/11/hystrix.html
[5]: http://eng.joingrouper.com/blog/2014/03/03/rails-the-missing-parts-interactors
[6]: https://github.com/collectiveidea/interactor
[7]: https://news.ycombinator.com/item?id=7335211
[8]: http://blog.8thlight.com/craig-demyanovich/2014/02/24/store-data-not-types.html
