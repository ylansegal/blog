---
layout: post
title: "Killing Me Softly"
date: 2014-04-21 15:39
comments: true
categories: 
- unix
---

Every once in a while, a process is stuck and doesn't want to respond. I usually just found the process id by using `ps` and then ran `kill -9 <pid>`. Why? Cargo-culting, mostly.

Recently a [friend and co-worker][1] shared with me a little bash function that will attempt to send less destructive signals to the process to allow it to have time to clean-up after itself. Eventually it ends up just sending the `KILL` signal, equivalent to `-9`. 

``` bash
function mercy_kill() {
  pid=$1
  for signal in TERM INT HUP KILL; do
    cmd="kill -s ${signal} $pid"
    echo $cmd
    eval $cmd
    for i in {0..19}; do
      if [ $(ps -p $pid|wc -l) -lt 2 ]; then
        echo "pid $pid no longer exists"
        return 0
      fi
      sleep 0.1
    done
  done
}
```

[1]: https://github.com/fallwith
