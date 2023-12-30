---
layout: post
title: "This Blog on Ruby 3.3.0"
date: 2023-12-30 09:28:26 -0800
categories:
- ruby
excerpt_separator: <!-- more -->
---

Per tradition, this Christmas a new version of `ruby` was [released](https://www.ruby-lang.org/en/news/2023/12/25/ruby-3-3-0-released/).

It promises performance improvements, especially with the YJIT turned on. Let's see how it does using `jekyll` the static site generator for this very blog.

## Before (ruby 3.2.2 without YJIT)

```
$ ruby -v
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin22]

$ jekyll build
Configuration file: /Users/ylansegal/Personal/blog/_config.yml
            Source: /Users/ylansegal/Personal/blog/src
       Destination: /Users/ylansegal/Personal/blog/_site
 Incremental build: disabled. Enable with --incremental
      Generating...
       Jekyll Feed: Generating feed for posts
                    done in 2.676 seconds.
 Auto-regeneration: disabled. Use --watch to enable.

$ jekyll build
[...]
                    done in 2.685 seconds.
$ jekyll build
[...]
                    done in 2.679 seconds.
```

Average: 2.68 seconds

## After (ruby 3.3.0 with YJIT)

```
$ ruby -v
ruby 3.3.0 (2023-12-25 revision 5124f9ac75) +YJIT [arm64-darwin23]

$ jekyll build
Configuration file: /Users/ylansegal/Personal/blog/_config.yml
            Source: /Users/ylansegal/Personal/blog/src
       Destination: /Users/ylansegal/Personal/blog/_site
 Incremental build: disabled. Enable with --incremental
      Generating...
       Jekyll Feed: Generating feed for posts
                    done in 2.079 seconds.
 Auto-regeneration: disabled. Use --watch to enable.

$ jekyll build
[..]
                    done in 2.212 seconds.

$ jekyll build
[...]
                    done in 2.163 seconds.
```

Average: 2.15 seconds

Of course this is unscientific, but 20% local reduction in build time is impressive!
