---
layout: post
title: "Finding Broken Links"
date: 2022-03-20 17:52:13 -0700
categories:
- unix
- web
excerpt_separator: <!-- more -->
---

HTML powers the web, in great part by providing a way to link to other content. Every website maintainer dreads having broken links: Those that when followed result in a document that is no longer there.

I remember that when I first learned to hand-write HTML (yes, last century) I used a Windows utility called [Xenu's Link Sleuth](https://xenus-link-sleuth.en.softonic.com/). It allowed me to check my site for broken links. I don't use Windows anymore, but `wget` turns out to have everything I need.

Based on [an article by Digital Ocean](https://www.digitalocean.com/community/tutorials/how-to-find-broken-links-on-your-website-using-wget-on-debian-7), I created a script that checks for broken internal[^1] links:

```shell
#!/usr/bin/env bash
# Finds broken links for a site
#
# Usage
# find_broken_links http://localhost:3000

! wget --spider --recursive --no-directories --no-verbose $1 2>&1 | grep -B1 -E '(broken link!|failed:)'
```

It uses `wget` to spider (or crawl) a given URL and recursively check all links. All output is redirected and filtered to print only the broken links or other failures. The `!` before the invocation inverts the process output: `grep` typically returns a non-zero (error) code if there is no output, but in this case we consider that a success.

Running against this blog found 3 broken links!

Now, my Makefile has a `test` target:

```
test:
  find_broken_links http://127.0.0.1:4000
```

I run it before every deployment (including posting this very post), to ensure I have not introduced bad link :-)

[^1]: By default, `wget` will not spider links in other hosts, but can be configured with `--span-hosts` to do so, to also check that external links are still valid. While I consider a broken internal link something that **I** must fix, a broken external link is something that another website operator broke. Their url is no longer valid, but I don't necessarily want to do anything about it.
