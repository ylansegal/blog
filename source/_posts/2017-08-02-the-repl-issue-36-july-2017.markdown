---
layout: post
title: "The REPL: Issue 36 - July 2017"
date: 2017-08-02 18:14:17 -0700
comments: true
categories:
- the repl
---

### [Is Ruby Too Slow For Web-Scale?][scale]

Nate Berkopec writes a long post about Ruby performance and how it affects web applications. Not-withstanding the click-bait title, Nate brings up that raw performance might not be as significant as many teams would like to think. Many of use work on applications that receive only a modest amount of traffic. In this organizations, the trade-off between engineering productivity and server costs tilts towards productivity.

### [Five ways to paginate in Postgres, from the basic to the exotic][pagination]

Most web-applications encounter a need to paginate results into multiple page loads. Joe Nelson works his way from the most simple implementations (`LIMIT` and `OFFSET`) to the more complex. He discusses the benefits and drawbacks of each. The techniques described cover most of the typical web-application needs. The more exotic ones -- like stable page loads that return the same results even if elements are added or deleted from the collection -- require more exotic solutions. They are usually expensive to compute.

### [An engineer’s guide to cloud capacity planning][capacity]

Patrick McKenzie writes a great guide on how to plan server capacity in the cloud. He covers decoupling the applications with knowledge from it's deployment environment, advises to automate provisioning and deployment, covers how to estimate capacity and what to focus on as traffic grows. This is another great article by [Increment][increment].

[scale]: https://www.speedshop.co/2017/07/11/is-ruby-too-slow-for-web-scale.html
[pagination]: https://www.citusdata.com/blog/2016/03/30/five-ways-to-paginate/
[capacity]: https://increment.com/cloud/an-engineers-guide-to-cloud-capacity-planning/
[increment]: https://increment.com/
