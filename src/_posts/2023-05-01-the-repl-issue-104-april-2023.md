---
layout: post
title: "The REPL: Issue 104 - April 2023"
date: 2023-05-01 14:58:17 -0700
categories:
- the repl
- performance
- make
- unix
excerpt_separator: <!-- more -->
---

### [Making A Network Call: Mitigate The Risk][1]

Nate Berkopec, well knows for his Ruby/Rails performance work, writes some good advice to mitigating the performance risk of making network calls: Make calls whenever possible in background jobs, set aggressive network timeouts, and use circuit breakers to fail fast when you detect a system is misbehaving.

>  I'm not saying this is easy, I'm saying it's necessary.

### [Makefile Tutorial By Example][2]

`make` is tried and true technology. I don't write `Makefile`s often. When I do, having a mental model of how `make` treats dependencies helps make the whole enterprise more efficient and enjoyable. This guide has plenty of material to get you started.

### [Pure sh Bible][3]

Very ingenious collection of recipes for `sh`, that avoid using new processes. Some of the syntax is clever, but terrifying to read. Case in point:

```sh
trim_string() {
    trim=${1#${1%%[![:space:]]*}}
    trim=${trim%${trim##*[![:space:]]}}

    printf '%s\n' "$trim"
}
```

[1]: https://mailchi.mp/railsspeed/mitigating-risk-during-the-request-http-to-3rd-parties?e=ecb13d72a8
[2]: https://makefiletutorial.com/
[3]: https://github.com/dylanaraps/pure-sh-bible
