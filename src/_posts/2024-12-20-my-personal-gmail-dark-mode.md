---
layout: post
title: "My Personal GMail Dark Mode"
date: 2024-12-20 14:38:51 -0800
categories:
- web
excerpt_separator: <!-- more -->
---

I switched about a month ago to use dark mode on my Mac and iPhone. It's been a great experience, except for using GMail on the web. The GMail iOS app has a beutiful dark icon, and a great dark mode UI.

GMail on the web... does not. Other Google websites (Drive, Calendar, etc) have a working dark mode. I don't understand why GMail does not.

I solved it by:
1. Installing the [Userscripts](https://apps.apple.com/us/app/userscripts/id1463298887) Safari extensions, my current browser of choice.
2. Adding a custom CSS style:

```css
/* ==UserStyle==
@name        Gmail Dark Mode
@description Quick Hack for Gmail Dark mode
@match       https://mail.google.com/*
==/UserStyle== */
@media (prefers-color-scheme: dark) {
  html {
    filter: invert(90%) hue-rotate(180deg);
  }

  iframe, video, img {
    filter: invert(90%) hue-rotate(-180deg);
  }
}
```

Of course, it's not as polished as the iOS GMail dark UI, but it does the trick!
