---
layout: post
title: I've Disallowed LLMs
date: 2026-02-17 16:24:00.000000000 -08:00
categories:
- web
excerpt_separator: "<!-- more -->"
syndication_excerpt: As an experiment, I changed the `robots.txt` on this blog to
  disallow LLMs from crawling it. It didn't make a difference.
syndicated:
- platform: bluesky
  url: https://bsky.app/profile/ylan.segal-family.com/post/3mf3tmq7vcp2w
  date: '2026-02-17 16:37:42 -0800'
---

As an experiment, I changed the `robots.txt` on this blog to disallow LLMs from crawling it. I saw a reference -- lost now in my notes -- to something like this:

```
# Disallow AI training

# OpenAI - https://platform.openai.com/docs/bots
User-agent: GPTBot
Disallow: /

# Anthropic - https://support.claude.com/en/articles/8896518-does-anthropic-crawl-data-from-the-web-and-how-can-site-owners-block-the-crawler
User-agent: ClaudeBot
User-agent: anthropic-ai
Disallow: /

# Google - https://developers.google.com/crawling/docs/crawlers-fetchers/google-common-crawlers#google-extended
User-agent: Google-Extended
Disallow: /

# Apple - https://support.apple.com/en-us/119829
User-agent: Applebot-Extended
Disallow: /

# Common Crawl - https://commoncrawl.org/ccbot
User-agent: CCBot
Disallow: /

# Meta/Facebook - https://developers.facebook.com/docs/sharing/webmasters/web-crawlers
User-agent: Meta-ExternalAgent
User-agent: FacebookBot
Disallow: /

# ByteDance/TikTok
User-agent: Bytespider
Disallow: /

# Amazon - https://developer.amazon.com/amazonbot
User-agent: Amazonbot
Disallow: /

# Ai2 - https://allenai.org/crawler
User-agent: AI2Bot
Disallow: /

# Bright Data - https://brightdata.com/brightbot
User-agent: Brightbot 1.0
Disallow: /

# Huawei/PetalBot
User-agent: PetalBot
Disallow: /

# Meltwater/YaK
User-agent: YaK
Disallow: /

# Yandex
User-agent: YandexAdditional
User-agent: YandexAdditionalBot
Disallow: /

# A draft standards-based way to disable AI training.
User-Agent: *
# https://www.ietf.org/archive/id/draft-ietf-aipref-attach-04.html
# Content-Usage: train-ai=n
Allow: /

# Last updated: January 10, 2026
```

That change went live on 2026-01-13. Now, after roughly a month, I can see what effect it had on traffic, as measured in my server logs rather than JS artifacts injected on page load.

![Traffic from 2025-12 to 2026-02](/assets/images/llm-disallow-traffic.png)

Can you spot when the traffic dropped off? Neither can I. <span class="emoji">🤷🏻‍♂️</span>
