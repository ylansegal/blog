---
layout: post
title: "Hazmat Ratchet"
date: 2023-07-13 12:16:54 -0700
categories:
- software
- percolations
excerpt_separator: <!-- more -->
---

I've just read a [blog post on Fly.io](https://fly.io/blog/tokenized-tokens/) that says:

> So, a few months back, during an integration with a 3rd party API that relied on OAuth2 tokens, we drew a line: ⚡ henceforth, hazmat shall only be removed from Rails, never added ⚡.

Hazmat. As in hazardous materials. [Wikipedia](https://en.wikipedia.org/wiki/Dangerous_goods) defines it as:

> Dangerous goods, abbreviated DG, are substances that when transported are a risk to health, safety, property or the environment. Certain dangerous goods that pose risks even when not being transported are known as hazardous materials (syllabically abbreviated as HAZMAT or hazmat)

I've never heard of software secrets being described as hazmat. It's an apt metaphor. They can be dangerous, even when not being transmitted. We should be careful on how we handle them. Hazmat evokes specialized suits and gear. It's not a bad mental image when dealing with secrets!

The second interesting part about the line in the blog post is the "only removed, never added". That makes me think of a ratchet, defined as:

```
ratchet1 | ˈraCHət |
noun
1 a device consisting of a bar or wheel with a set of angled teeth in which
  a cog or tooth engages, allowing motion in one direction only
2 a situation or process that is perceived to be changing in a series of irreversible
  steps
```

A **hazmat ratchet**, if you will.
