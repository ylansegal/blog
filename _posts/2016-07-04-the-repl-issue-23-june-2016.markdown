---
layout: post
title: "The REPL: Issue 23 - June 2016"
date: 2016-07-04 13:33:44 -0700
comments: true
categories:
- the repl
---

### [Flirting with Crystal, a Rubyist Perspective][1]

AkitaOnRails write on his perspective on [Crystal][3] -- a new programming language that aims to be type-checked, compile to native code and have a syntax similar to Ruby. I have [played with Crystal][9] myself recently and found the discussion thoughtful and interesting. Lately, it seems that Crystal is gathering some steam, especially since Mike Perham [ported Sidekiq][2] and has been tweeting about it.

### [My Candidate Description][4]

Erik Dietrich lays down his requirements that companies must meet for him to consider working for them. My list would certainly be different, but that is the point. There is high demand for Software Engineers. It might now hold for other industries, where people don't have much choice but to take what is offered. Instead of taking the first option that is presented, let's be more mindful of what _we_ want from an employer.

### [StartEncrypt considered harmful today][5]

Notwithstanding the cliché title, this articles shows how easy it is to get security wrong. The tragic part is that the security flaws come from a Certificate Authority, StartCom. As it happens, it's the CA used for the certificate of this very blog (at the time of writing). I'll have to re-consider that decision soon. Also clear from the story, is that [Let's Encrypt][6] is putting some pressure on CAs -- which functionality StartCom was trying to replicate. Some CAs are even trying to [steal their brand][7].

### [moreutils][8]

Unix tools have been around for a long time and haven't changed much. Joey Hess took it upon himself to evaluate new simple tools that he thought are missing (and rejected some ideas in the process). I downloaded `moreutils` as soon as I read the descriptions. I am sure they will come in handy very soon. Kudos.

[1]: http://www.akitaonrails.com/2016/05/31/flirting-with-crystal-a-rubyist-perspective
[2]: https://github.com/mperham/sidekiq.cr/
[3]: https://crystal-lang.org/
[4]: http://www.daedtech.com/my-candidate-description/
[5]: https://www.computest.nl/blog/startencrypt-considered-harmful-today/
[6]: https://letsencrypt.org/
[7]: https://letsencrypt.org/2016/06/23/defending-our-brand.html
[8]: https://joeyh.name/code/moreutils/
[9]: https://github.com/ylansegal/uniq_history.cr
