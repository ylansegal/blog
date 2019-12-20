---
layout: post
title: "Faster Rspec: jRuby, Spork, Nailgun and Bundler Binstubs"
date: 2013-03-27 20:05
comments: true
categories:
- rspec
- jruby
- bundler
---

I recently discovered that [bundler][1] has a feature to create binstubs, so I decided to redo [my benchmarks][2] of
running a single pending spec (but including the complete spec_helper for my project).

To create rspec binstubs:

```
$ bundle binstubs rspec-core
```

Here are my findings:

| Description                |  | Command                                    | Avg. Time (3 runs) |
|:---------------------------|:-|:-------------------------------------------|-------------------:|
| Bundled Rspec              |  | <code>bundle exec rspec</code>             |            61.76 s |
| Binstubs                   |  | <code>bin/rspec</code>                     |            50.24 s |
| Binstubs + Spork           |  | <code>bin/rspec --drb</code>               |            17.43 s |
| Binstubs + Spork + Nailgun |  | <code>jruby --ng -S bin/rspec --drb</code> |             6.65 s |

---

It is still slower than I would like, but well worth the effort. Since I didn't want to remember the specific invocation depending on what I have running, I have a script that will use binstubs, nailgun and/or spork if available:

```shell
#! /bin/bash

# Looking for binstubs
if [ -f ./bin/rspec ]; then
  RSPEC="bin/rspec"
else
  RSPEC="bundle exec rspec"
fi

NAILGUN_PORT=2113
SPORK_PORT=8989

# Looking for nailgun
lsof -i :$NAILGUN_PORT > /dev/null
if [ $? == 0 ]; then
  RSPEC="jruby --ng -S $RSPEC"
fi

# Looking for spork
lsof -i :$SPORK_PORT > /dev/null
if [ $? == 0 ]; then
  RSPEC="$RSPEC --drb"
fi

CMD="$RSPEC $@"
echo $CMD
$CMD
```

[1]: http://gembundler.com/
[2]: /blog/2012/10/02/faster-rspec-jruby/
