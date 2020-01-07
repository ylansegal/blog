---
layout: post
title: "The REPL: Issue 29 - December 2016"
date: 2017-01-02 11:36:49 -0800
comments: true
categories:
  - the rep
excerpt_separator: <!-- more -->
---

### [Learn Graphviz and Up Your Diagramming Game][graphviz]

I've bumped with Graphviz in the past only indirectly. After reading this article, I will definitely keep it in mind when needing to create diagrams in the future. I like the idea of specifying the relationships in a diagram in text -- and manage it with source control -- and then generating a graph from it.

### [Microservices? Please, Don't][microservices]

Sean Kelly explores why some of the often-repeated arguments for microservices. Certainly, some of the benefits of microservices can be achieved without needing to separate them into different web applications, which in itself can brings complications in deployment, coordination and increased network interaction.

### [RbNaCL: The Ruby Cryptography Library][rbnacl]

This repository is a great idea: Provide a cryptographic library that makes it easy and straightforward to use high-level cryptography correctly, and avoid the many pitfalls of trying to assemble a secure system from cryptographic primitives. The APIs are designed to provide abstractions like public-key / secret-key encryption, digital signatures, etc.

[graphviz]: http://naildrivin5.com/blog/2016/12/08/learn-graphviz-and-up-your-diagramming-game.html
[microservices]: https://dzone.com/articles/microservices-please-dont
[rbnacl]: https://github.com/cryptosphere/rbnacl/blob/master/README.md
