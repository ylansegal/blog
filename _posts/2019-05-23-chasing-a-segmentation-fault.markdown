---
layout: post
title: "Chasing a Segmentation fault"
date: 2019-05-23 14:54:02 -0700
comments: true
categories:
- ruby
---

Recently, I chased down a segmentation fault occurring in one of our production servers. A segmentation fault cannot be triggered by code is that written completely in Ruby, barring a bug in Ruby itself. The VM manages the memory, making it impossible to access memory in violation of the OS rules.

From [Wikipedia](https://en.wikipedia.org/wiki/Segmentation_fault)

> In computing, a segmentation fault or access violation is a fault, or failure condition, raised by hardware with memory protection, notifying an operating system the software has attempted to access a restricted area of memory.

Not surprisingly, I tracked it down to a [gem with a C extension](https://github.com/rails-sqlserver/tiny_tds): A database driver for MS SQL. The issue can be reproduced by attempting to read results from a connection after it has been closed. I don't expect to be able to read the results, but I expected an exception to be raised, not for the whole process to crash. I [reported the bug](https://github.com/procore/erp-spectrum/pull/627).

Interestingly, I can also reproduce the segfault by running the garbage collector (GC) manually. The way we interact with the gem is by instantiating a `TinyTds::Client` object, and executing some SQL. It then returns a `TinyTds::Result` object. The segfault is triggered when (1) the client object is no longer in scope (thus eligible for garbage collection), (2) the GC runs, and (3) then the result object is used. Since normally the GC runs at Ruby's pleasure, we see non-deterministic segfaults in production, with varying stack traces.

The gem hasn't been fixed yet, but I believe I can solve our particular issue by re-organizing my code so that the client and result objects are always in scope at the same time. The most expedient solution was to read all the results into Ruby as soon as possible. I was concerned that this would increase the memory usage. This was a good opportunity to use [benchmark-memory](https://github.com/michaelherold/benchmark-memory).

```ruby
require 'benchmark/memory'

Benchmark.memory do |x|
  x.report('with workaround') { Existing.run  }
  x.report('without workaround') { Workaround.run }

  x.compare!
end
```

Its output is handy.

```
Calculating -------------------------------------
     with workaround     1.338B memsize (    19.558M retained)
                        17.715M objects (     6.234k retained)
                        50.000  strings (    50.000  retained)
  without workaround     1.397B memsize (    12.303k retained)
                        18.828M objects (   109.000  retained)
                        50.000  strings (    19.000  retained)

Comparison:
     with workaround: 1337820417 allocated
  without workaround: 1396586267 allocated - 1.04x more
```

Looks like there was no need for concern.
