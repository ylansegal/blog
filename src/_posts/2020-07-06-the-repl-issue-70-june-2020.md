---
layout: post
title: "The REPL: Issue 70 - June 2020"
date: 2020-07-06 11:49:57 -0700
categories:
- the repl
excerpt_separator: <!-- more -->
---

[Why Your Microservices Architecture Needs Aggregates][aggregates]

Dave Taubler writes a comprehensive piece about the use of Domain-Driven Design concepts in micro-service architectures. The use of aggregates, entities and invariants can prevent unwanted dependencies between objects, leaky references and delineate a clear boundary around groups of data. Eventually, the use of aggregates simplifies things like sharding, message passing, idempotent retries, caching and tracking changes.

I've been thinking about event schema design a lot lately, and found interesting that in the context of messaging between services via a message broker, the author advises to use the same aggregate!:

> So what should we pass as our messages?
> As it turns out, if we’ve embraced Aggregates, then we have our clear answer. Anytime an Aggregate is changed, that Aggregate should be passed as the message.

[Why Tacit Knowledge is More Important Than Deliberate Practice][tacit]

The author talks about tacit knowledge:

> Tacit knowledge is knowledge that cannot be captured through words alone.

Most of the article is new to me: The idea that there is knowledge that can't be expressed through words alone, and that is distinct and separate from deliberate practice.

I can relate to the part about expertise: An experience software engineer can come up with a good design -- or critique an existing one -- in seconds. Clearly, they is not going down a list of heuristics one by one. In their mind, the pattern have been established and the brain quickly comes up with a solution. This is the subject of "Blink" by Malcom Gladwell.

My sense is that as a person gains expertise, they gain intuition about the field, and their brain gets wired for rapid pattern recognition. They reach this stage before they can put in words _why_ their intuition went in that direction. That actually comes in a later part of expertise, when the person can articulate and reason about the intuition and communicate it to others.

I believe the author is saying that because people can't articulate their intuition, that means that they hold tacit knowledge that _can't_ be articulated. I think that is a flawed syllogism. In fact, the author points at examples of fields were it was previously thought that apprenticeship was the only way to transfer tacit knowledge. Then someone came along and turned that knowledge into explicit knowledge.

I believe that knowledge can be gained by learning explicit and implicit knowledge. On one end, reading books and academic material goes a long way, but at times it can be disconnected from application. The proverbial ivory tower. On the other end, there is apprenticeships that focus on following rules and procedures, without real understanding, that can nevertheless bring proficiency: Most people learn to play the guitar like this. Of course, there is a hybrid: Academic project-based learning that aims to cover both modes of learning. In my experience all 3 can work, even for the same person. It depends a lot on familiarity with the material adjacent to the new material that we are learning, and how the new materials fall into the existing subject's mental model.

There are interesting points in the article. *My* takeaway is that the real jump in understanding is when you can turn tacit knowledge into explicit knowledge, which is distinct from the author's point about embracing tacit knowledge.

[aggregates]: https://medium.com/better-programming/why-your-microservices-architecture-needs-aggregates-342b16dd9b6d
[tacit]: https://commoncog.com/blog/tacit-knowledge-is-a-real-thing/
