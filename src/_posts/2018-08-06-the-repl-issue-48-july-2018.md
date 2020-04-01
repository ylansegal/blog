---
layout: post
title: "The REPL: Issue 48 - July 2018"
date: 2018-08-06 16:31:16 -0700
comments: true
categories:
- the repl
excerpt_separator: <!-- more -->
---

### [Web Architecture 101][1]

The world-wide web is built on top of many abstractions. That is what makes it powerful. As a user, we are typically just concerned with a browser and a "site". When I first started programming for the web, I learned about HTTP, request and responses. Sometimes, one needs to dig deeper into common architecture patterns. In this article, Jonathan Fulton covers some of that architecture: DNS, load balancers, web and application servers, databases, caching. I found it to be a very useful reference. Note: As is always the case with computers, there are more levels of abstraction to learn: TCP, IP, UDP, TLS, etc.

### [Scaling the GitLab database][2]

Yorick Peterse discusses some of the scaling issues that GitLab went through and how they resolved them. I find these type of articles very enlightening. Both for the solution they chose and for those that they discarded: Your particular scaling problem might look different, making one of those solutions more attractive.

### [Queries on Rails - Showcasing Active Record and Arel][3]

Pedro Rolo discusses how to go beyond basic queries with `ActiveRecord` and `Arel`. I personally use techniques similar to the ones outlined in the article often. *Caution:* `Arel` is considered private API by Rails maintainers. If you decide to use it, there might be some work needed to ensure your code works when upgrading Rails. I've never had a significant problem with that, provided that I have good tests around complex queries. I much prefer `Arel` to using long and complicated `sql` fragments as strings. I believe those are even more brittle.

[1]: https://engineering.videoblocks.com/web-architecture-101-a3224e126947?ref=abhimanyuhttps%3A%2F%2Fengineering.videoblocks.com%2Fweb-architecture-101-a3224e126947%3Fref%3Dabhimanyu
[2]: https://about.gitlab.com/2017/10/02/scaling-the-gitlab-database/
[3]: https://www.imaginarycloud.com/blog/queries-on-rails/
