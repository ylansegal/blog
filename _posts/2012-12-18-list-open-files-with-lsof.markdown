---
layout: post
title: "List Open Files With lsof"
date: 2012-12-18 19:50
comments: true
categories:
- unix
---

In the UNIX paradigm, [everything is a file system][1]. So, it makes sense that there is a utility to work with open
files.

A common use case is to try to eject a mounted drive or clear the trash and get a warning about a locked file. What
process has this file or folder open?

``` bash
$ lsof /Volumes/Personal/blog/source/_posts
COMMAND     PID      USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
Sublime   13472 ylansegal  cwd    DIR   14,7      442 6072 /Volumes/Personal/blog/source/_posts
```

Since everything is a file, it works just as well with ports:

``` bash
$ lsof -i :4000
COMMAND   PID      USER   FD   TYPE             DEVICE SIZE/OFF NODE NAME
ruby    20740 ylansegal    7u  IPv4 0xffffff80158d6de0      0t0  TCP *:terabase (LISTEN)
```

Or you can check the files for a specific program:

``` bash
$  lsof -p 21286
COMMAND   PID      USER   FD     TYPE DEVICE  SIZE/OFF    NODE NAME
tail    21286 ylansegal  cwd      DIR   14,7       850      28 /Volumes/Personal/blog
tail    21286 ylansegal  txt      REG   14,4     57488    9770 /usr/bin/tail
tail    21286 ylansegal  txt      REG   14,4    599280    8989 /usr/lib/dyld
tail    21286 ylansegal  txt      REG   14,4 299110400 3283993 /private/var/db/dyld/dyld_shared_cache_x86_64
tail    21286 ylansegal    0u     CHR   16,1  0t238994     723 /dev/ttys001
tail    21286 ylansegal    1u     CHR   16,1  0t238994     723 /dev/ttys001
tail    21286 ylansegal    2u     CHR   16,1  0t238994     723 /dev/ttys001
tail    21286 ylansegal    3r     REG   14,7      1450     240 /Volumes/Personal/blog/Gemfile.lock
tail    21286 ylansegal    4u  KQUEUE                          count=0, state=0x2
```

```lsof``` supports many, many options, read the [man pages][2] for more information.


[1]: http://en.wikipedia.org/wiki/Everything_is_a_file
[2]: http://linux.die.net/man/8/lsof