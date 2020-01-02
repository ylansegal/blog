---
layout: post
title: "Book Review: Building Microservices"
date: 2015-06-16 21:00:36 -0700
comments: true
categories:
- books
- microservices
---

There is a lot of buzz around microservices and service-oriented architecture, at least in the corner of the internet that I frequent. Heavyweights in the Ruby community, like Heroku think [microservices matter][3]. It seems that enough people are adopting microservices head-first that some influential people in the community have started warning that it might not be for everyone. Martin Fowler thinks there is a [microservices permium][2] to pay and that you probably want to [start with a monolith][1]. Avdi Grim is of the opinion that people are adopting microservices for the [wrong reasons][4]. And David Heinemeier Hansson, devoted a portion of his [RailsConf 2015 keynote][5] to denouncing the practice.

In "Building Microservices. Designing Fine-Grained Systems", Sam Newman explores the practice of microservices. Starting with a definition of just how small they are (something that can be re-built in 2 weeks time), the book covers in depth what microservices are good for and what having a fleet of them looks in practice.

As one would expect, the author is partial to microservices, but acknowledges that they are not a good fit for every organization and every project. For example, when a start-up is still exploring their domain and iterating fast, the boundaries of their systems are hard to predict and API might churn significantly. Similarly, teams that are not leveraging cloud computing and have the necessary automation in place to provision and deploy new services might not find much success in having numerous systems to support in production. The author makes well-reasoned arguments for organizations only considering microservices when they have great automated-test coverage, continuous integration in place and automated deployments (preferably continuous delivery).

Along the way, Mr. Newman also points out that, like most things in Engineering, there are trade-offs to be made: Latency and develops complexity, chief among them. However, there is also a lot to be gained: being able to mix-and-match technology stacks, resilience of the whole system (assuming that the proper precautions are in place), independent scaling for each piece, deployment in stages, organizational alignment, the ability to replace parts as needed and maintaining team velocity.

I though the book to be an overall good read for those starting to dip their toes in the microservices world.

[1]: http://martinfowler.com/bliki/MonolithFirst.html
[2]: http://martinfowler.com/bliki/MicroservicePremium.html
[3]: https://blog.heroku.com/archives/2015/1/20/why_microservices_matter
[4]: http://devblog.avdi.org/2014/11/19/frog-and-toad-willpower-and-microservice-architecture/
[5]: https://www.youtube.com/watch?v=KJVTM7mE1Cc
