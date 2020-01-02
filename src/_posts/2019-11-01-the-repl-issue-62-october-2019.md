---
layout: post
title: "The REPL: Issue 62 - October 2019"
date: 2019-11-01 14:51:27 -0700
comments: true
categories:
- the repl
---

### [The Night Watch][night]
In this article James Mickens writes about being a systems programmer. The writing is witty and funny. It's not new, but it is new to me. A few choice quotes:

> One time I tried to create a list<map<int>>, and my syntax errors caused the dead to walk among the living. Such things are clearly unfortunate.

> ...

> Indeed, the common discovery mode for an impossibly large buffer error is that your program seems to be working fine, and then it tries to display a string that should say “Hello world,” but instead it prints “#a[5]:3!” or another syntactically correct Perl script

> ...

> However, when HCI people debug their code, it’s like an art show or a meeting of the United Nations. There are tea breaks and witticisms exchanged in French; wearing a non-functional scarf is optional, but encouraged.

> ...

> Do you see the difference between our lives? When you asked a girl to the prom, you discovered that her father was a cop. When I asked a girl to the prom, I DISCOVERED THAT HER FATHER WAS STALIN.

### [Empathy is a Technical Skill][empathy]

Andrea Goulet writes an interesting article about empathy. The takeaway is that technical-minded folks should think of empathy as a skill that can be learned, and used effectively to achieve your aims. From experience, I can attest that increasing your empathy is like having a super power.

### [pg_flame][pg_flame]

This project looks really promising. It formats the output of Postgres `EXPLAIN ANALYZE` as a flame graph, which can help in figuring out which parts of your queries are worth digging into.

[night]: http://scholar.harvard.edu/files/mickens/files/thenightwatch.pdf
[empathy]: https://www.infoq.com/articles/empathy-technical-skill/
[pg_flame]: https://github.com/mgartner/pg_flame
