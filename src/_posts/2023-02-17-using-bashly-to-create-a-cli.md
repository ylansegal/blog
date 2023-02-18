---
layout: post
title: "Using bashly to create a CLI"
date: 2023-02-17 17:29:08 -0800
categories:
- unix
- bash
excerpt_separator: <!-- more -->
---

[bashly](https://bashly.dannyb.co) is a command-line application that let's you generate feature-rich command line tools. The idea is that you specify via a YAML file what subcommands, arguments, flags and environment variables you want for your executable, and `bashly` takes care of generating all the boilerplate on a bash script, so that you can focus on your code. Many languages support similar via libraries, like [optparse](https://github.com/ruby/optparse) in ruby.

I recently used it to port a series of scripts for personal use that where all part of a series of commands I use to manage my [personal note taking](https://ylan.segal-family.com/blog/2018/08/26/on-taking-notes/). I turned the all those separate scripts into a CLI with subcommands. Instead of `zk_title` and `zk_today`, I know have `zk title` and `zk today`, among others).

Here are my observations:

1. The documentation is well done. In particular the [examples](https://bashly.dannyb.co/examples/) showed me how to do everything I needed.
2. The ability to check for required environment variables was very useful. If only a particular command requires a certain environment variable, that can be configured too.
3. Reading from `stdin` or from a file is a very common use case. It's well supported.
4. Commands can be aliased to shorter names.
5. Flag handling is great. Short flags can be combined (i.e. `zk title -ps` instead of `zk title -p -s`)
6. Each command lives in it's own file. If needed, custom functions that are called from other commands are supported.
7. Some of my previous commands were written in Ruby. `bashly` supports heredocs, which make it possible to continue using ruby for portions of your script, albeit this is a bit of a hack and makes the script less portable:


```bash
/usr/bin/env ruby - ${arguments} <<-RUBY
puts "hello #{ARGV}"
RUBY
```

Note that for heredocs to work, the following environment variable needs to be set `BASHLY_TAB_INDENT=1`.

Overall, I was happy with the results. All the boilerplate code like creating global and command `--help` output, argument and environment variable checking, and flag handling was abstracted away.
