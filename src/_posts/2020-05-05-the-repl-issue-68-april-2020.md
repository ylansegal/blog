---
layout: post
title: "The REPL: Issue 68 - April 2020"
date: 2020-05-05 11:18:06 -0700
categories:
- the repl
excerpt_separator: <!-- more -->
---

I've been spending a lot of time thinking about bi-temporal data in the last few weeks. You can read what I've written about it in [Bi-Temporal Data]({% post_url 2020-04-18-til-bitemporal-data %}) and [Modeling Bi-Temporal Deletions]({% post_url 2020-04-24-modeling-bitemporal-deletions %}).

### [The Case for Bitemporal Data][bitemp_talk]

Craig Baumunk presents at the NJ SQL Server User Group on bi-temporal data. He goes over the differences between non-temporal, valid temporal, transaction temporal modeling and the different types of problems that they solve. He makes the case of why bi-temporal data is superior to all the previous issues and what the implications are. The presentation is from 2011, but it is still as relevant as ever. Note that the presentation is broken up into 7 different parts.

### [Bi-temporal data modeling with Envelope][bitemp_post]

Jeremy Beard covers the importance of bi-temporal data modeling, and the type of problems that it can solve. Using a credit score example, he builds up the modeling bit by bit in an intuitive way. The second portion of the article focuses specifically on the implementation in Cloudera EDH, which I don't use.

### [Principles and priorities ][principles]

Jeremy Keith writes on how to think about design principles. Sometimes, design principles can be truisms that can be less than useful (e.g. *Make it usable.*). Expressing principles as a set of priorities, makes them more useful and actionable (e.g. *Usability, even over profitability*). As an example, he uses the HTML design principles as:

>   Users, even over authors.
    Authors, even over implementors.
    Implementors, even over specifiers.
    Specifiers, even over theoretical purity.


[bitemp_talk]: https://www.youtube.com/watch?v=PuocT5wUgJ4
[bitemp_post]: https://blog.cloudera.com/bi-temporal-data-modeling-with-envelope/
[principles]: https://adactio.com/journal/16811
