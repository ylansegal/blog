---
layout: post
title: "The REPL: Issue 124 - December 2024"
date: 2025-01-03 10:50:36 -0800
categories:
excerpt_separator: <!-- more -->
---

### [Rails is better low code than low code](https://radanskoric.com/articles/rails-is-better-low-code-than-low-code)

Radan Skorić's points out that the argument for low-code (and even low-code) is that it can get you to your goal faster, and by people that are not experienced programmers. It resonates with me that it can quickly fall apart, once your applications reached a point that is not the platform use case.

I recently learned about a person I know that used one of those low-code platforms to quickly build an application that could be web-native, and also a native Android and iPhone app. Once the web portion was launched, it quickly got into performance issues, because each page was making hundreds (or even thousands) of AJAX requests to the server. However, he couldn't really fix the problem, because the platform was not design to deal with the level of data that they wanted. They were stuck.

### [Trying out Solid Queue and Mission Control with PostgreSQL](https://andyatkinson.com/solid-queue-mission-control-rails-postgresql)

Andrew Atkinson writes ab out his experience with Solid Queue and Postgres. I'm keeping an eye on Solid Queue, but have not yet made the switch from GoodJob.
