---
layout: post
title: "Better Performance On Heroku: Thin vs. Unicorn vs. Puma"
date: 2012-08-20 20:01
comments: true
categories:
- heroku
- performance
---

**UPDATE**: These benchmarks where updated in [2013][6] and [2014][7].

---

Heroku's Cedar stack provides great flexibility in the type of processes you can run, including the
ability to choose which application server to deploy.

I have been running [thin][5], since it's the recommended option and also the safe default, since that is
what the app was running in the Bamboo stack, before migrating to Cedar.

However, I have read recently about [getting better performance][1] out of the same amount of dynos, and my
interest was piqued. Before heading straight for [Unicorn][3], I decided to give [Puma][2], the new kid on the block a try.

<!-- more -->

## Methodology

I decided that for any benchmark to be meaningful for me, I would need to measure *my app's* performance using all 3 servers. I used the default thin and puma configuration and used Unicorn with 3 worker processes.
The app itself uses Rails 3.2.8, running on ruby 1.9.3, with a Postgres database and Memcached. I tested the homepage for the app, which is heavily cached and should only require a single DB query for the current user. All tests were run when the caches were warm.

To test, I used [siege][4]:

```
siege -c$i -t30s $URL
```

I used different levels of concurrency (i: 1, 5, 10, 20, 40, 80), testing each for 30 seconds and focused on the average response time for an approximation of performance.

## Results & Interpretation

{% img /assets/images/response-time-thin-puma-unicorn.png %}

As the graph above shows, there doesn't seem to be a significant difference in performance using the 3 different servers up to 10 concurrent requests. After that, thin starts performing much worse than puma or unicorn. Overall, it looks like unicorn is a better bet. Of course, YMMV depending on your system's particulars.

---

**UPDATE**: I recetly took unicorn and puma for [another spin][6]

[1]: http://michaelvanrooijen.com/articles/2011/06/01-more-concurrency-on-a-single-heroku-dyno-with-the-new-celadon-cedar-stack/
[2]: http://puma.io/
[3]: http://unicorn.bogomips.org/
[4]: http://www.joedog.org/siege-home/
[5]: http://code.macournoyer.com/thin/
[6]: /blog/2013/05/20/unicorn-vs-puma-redux/
[7]: /blog/2014/05/13/unicorn-vs-puma-round-3/
