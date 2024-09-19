---
layout: post
title: "Using expect to tailor environment"
date: 2024-09-19 16:30:53 -0700
categories:
- unix
excerpt_separator: <!-- more -->
---

I recently learned to leverage `expect`. According to the man pages it is:

> expect - programmed dialogue with interactive programs

I often need to `ssh` into remote hosts that both are ephemeral and I don't have much control over. Any environment customization that I do is one-time only, because odds are that next time I connect, it will be to a different host. Yet, I'd like to be in a familiar environment. That is where `expect` comes in.

`expect` provides a DSL of sorts to _interactively_ use programs in the command line. I use it to front `ssh` and do a few common tasks every time I log in:


```
#!/usr/bin/env expect
# Front ssh and automate env settings once on remote machine

set environment [lindex $argv 0];

spawn ssh $environment
expect "\$ " {
  send ". entry.sh"

  send -- "alias db_replica='psql ..."
  send -- "\n"

  send -- "export EDITOR=nano"
  send -- "\n"

  expect "\$ " { interact }
}
```

That script:
1. Reads the first argument to it and sets to a local variable named "environment".
2. Starts an instance (`spawn`) of `ssh`, passing the value of environment to it.
3. It then waits (`expect`) until it reads a `$ `
4. It `send`s a few commands to source a file, create an alias, export a variable, etc.
5. It then `expect`s another prompt and starts and switches to interactive mode (`interact`)

That last steps is what "drops" me into the terminal in the remote host, personalized with my taste.

This is just the proverbial tip of the iceberg. The [expect manual](https://man7.org/linux/man-pages/man1/expect.1.html) has a lot more information.
