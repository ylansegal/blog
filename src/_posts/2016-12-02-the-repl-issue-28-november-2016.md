---
layout: post
title: "The REPL: Issue 28 - November 2016"
date: 2016-12-02 08:56:07 -0800
comments: true
categories:
  - the repl
excerpt_separator: <!-- more -->
---

### [Open-Sourcing Yelp's Data Pipeline][yelp]

The Yelp Engineering team has been posting regularly about they structure data consumption between different teams. The backbone of their system is Apache Kafka, but they have created a lot of tooling around it. In this announcement, they have open sourced (Apache License 2.0) many of these tools. [MySQL Streamer][streamer] pipes data from MySQL to Kafka. [Schematizer][schematizer] stores and tracks the various data schemas used throughout their pipeline. There is a lot to learn in this projects and the blog itself, which provides an overview of how they approach dealing with data.

## [Offshoring roulette: lessons from outsourcing to India, China and the Philippines][offshoring]

Troy Hunt writes a lengthy post about his experience offshoring development work to teams in India, China and the Philippines. He goes through the motivation for offshoring in the first place, the challanges and rewards, and the differences he encountered in different countries. His conclusion:

> if you're looking at hourly rate as a metric for outsourcing success, you're doing it very, very wrong!

## [NIST’s new password rules – what you need to know][nist]

The United States National Institute for Standards and Technology has come up with new guidelines for password policies. If you are wondering which password rules to follow in your product, these are a great baseline. Note that the NIST policies [contradict the FBI's][fbi]. While you are at it, consider if you actually need to store a password at all. Medium, for example, [emails you a link to log in][no_password]. Because of "forgot your password" functionality in most sites, access to your email is essentially equal to access to the site. Medium just made it explicit and removed the need for them to store users passwords. Those passwords are probably re-used elsewhere. If you don't store them, you can't loose them. Right?


[yelp]: https://engineeringblog.yelp.com/2016/11/open-sourcing-yelps-data-pipeline.html
[offshoring]: https://www.troyhunt.com/offshoring-roulette-lessons-from-outsourcing-to-india-china-and-the-philippines/
[nist]: https://nakedsecurity.sophos.com/2016/08/18/nists-new-password-rules-what-you-need-to-know/
[fbi]: https://motherboard.vice.com/read/the-fbi-is-wrongly-telling-people-to-change-passwords-frequently
[no_password]: https://blog.medium.com/signing-in-to-medium-by-email-aacc21134fcd#.g13f0slrc
[streamer]: https://github.com/Yelp/mysql_streamer
[schematizer]: https://github.com/Yelp/schematizer
