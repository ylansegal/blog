---
layout: post
title: "This Blog: 10 Years Later"
date: 2022-08-23 16:05:28 -0700
categories:
- writing
excerpt_separator: <!-- more -->
---

Ten years ago I published my [first post][1] in this blog. Let's look back.

I've published 210 posts:

```
$ ls src/_posts | wc -l
     210
```

Relatively evenly over the years:

```
$ ls src/_posts | cut -f1 -d'-' | sort | histogram | sort
           2012    11 ######################
           2013    12 ########################
           2014    19 ######################################
           2015    30 ############################################################
           2016    22 ############################################
           2017    21 ##########################################
           2018    18 ####################################
           2019    21 ##########################################
           2020    20 ########################################
           2021    22 ############################################
           2022    14 ############################
```

(See my post on [World Player Age][2] if you are curious about `histogram`)

And even more so if we count by month:

```
$ ls src/_posts | cut -f2 -d'-' | sort | histogram | sort
             01    19 ####################################################
             02    17 ###############################################
             03    17 ###############################################
             04    18 ##################################################
             05    22 ############################################################
             06    17 ###############################################
             07    16 ############################################
             08    19 ####################################################
             09    19 ####################################################
             10    16 ############################################
             11    16 ############################################
             12    14 #######################################
```

I've written almost 87,000 words (roughly 193 pages)

```
$ wc -w src/_posts/*
   86919 total
```

Some of the blog posts I am most proud of, are also the longest (`wc -w src/_posts/* | sort -r | head -n 10`):

| Word Count | Post                                                                                                                |
| ---------- | ------------------------------------------------------------------------------------------------------------------- |
| 3183       | [Deployments With Schema Migrations]({% post_url 2020-01-14-deployments-with-schema-migrations  %})                 |
| 2153       | [Bug Driven Design]({% post_url 2017-09-21-bug-driven-design  %})                                                   |
| 1966       | [Scratching An Itch With A Ge,]({% post_url 2016-01-28-scratching-an-itch-with-a-gem  %})                           |
| 1881       | [I Also Built a CLI Application With Crystal]({% post_url 2017-03-23-i-also-built-a-cli-application-in-crystal  %}) |
| 1672       | [Avro Schema Evolution]({% post_url 2020-05-26-avro-schema-evolution  %})                                                                |
| 1557       | [Enforcing Style]({% post_url 2016-12-22-enforcing-style  %})                                                                      |
| 1293       | [Bitemporal Data]({% post_url 2020-04-18-til-bitemporal-data  %})                                                                  |
| 1236       | [Abstractions With Database Views]({% post_url 2021-01-04-abstractions_with_database_views  %})                                                     |
| 1213       | [This Blog Is Now Delivered Over TLS]({% post_url 2016-02-10-this-blog-is-now-delivered-over-tls  %})                                                  |

And if you create a world cloud out of the [categories](/categories), I write about these topics:

![Category Cloud](/assets/images/10_years_tags.png)

Here is to the next 10 years!

[1]: {% post_url 2012-08-20-better-performance-on-heroku-thins-vs-unicorn-vs-puma %}
[2]: {% post_url 2014-06-30-world-cup-player-age %}
