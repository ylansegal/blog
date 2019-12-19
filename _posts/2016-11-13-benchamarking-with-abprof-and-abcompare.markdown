---
layout: post
title: "Benchamarking With abprof &amp; abcompare"
date: 2016-11-13 07:16:58 -0800
comments: true
categories:
  - ruby
  - unix
---

This week at RubyConf I learned about two new tools.

> ripgrep (rg) combines the usability of The Silver Searcher (an ack clone) with the raw speed of grep.

And `abcompare`:

> Determine which of two programs is faster, statistically.

Let's use `abcompare` to check the speed of `ag` against `rg`.


```
$ abcompare "ag 'protected$'" "rg 'protected$'"
...
Based on measured P value 1.938532867962195e-05, we believe there is a speed difference.
As of end of run, p value is 1.938532867962195e-05. Now run more times to check, or with lower p.
Lower (faster?) process is 2, command line: "rg 'protected$'"
Lower command is (very) roughly 2.804074569852101 times lower (faster?) -- assuming linear sampling, checking at median.
         Checking at mean, it would be 2.794296598639456 lower (faster?).

Process 1 mean result: 0.08557533333333334
Process 1 median result: 0.085886
Process 2 mean result: 0.030625
Process 2 median result: 0.030629
```

And:

```
$ abcompare "ag '< ApiController'" "rg '< ApiController'"
...
Trial 3, Welch's T-test p value: 0.00019649943055588537   (Guessed smaller: 2)
Based on measured P value 0.00019649943055588537, we believe there is a speed difference.
As of end of run, p value is 0.00019649943055588537. Now run more times to check, or with lower p.
Lower (faster?) process is 2, command line: "rg '< ApiController'"
Lower command is (very) roughly 2.3338791691803844 times lower (faster?) -- assuming linear sampling, checking at median.
         Checking at mean, it would be 2.408501905599531 lower (faster?).

Process 1 mean result: 0.082154
Process 1 median result: 0.08124
Process 2 mean result: 0.03411
Process 2 median result: 0.034809
```

The above was tried on my largest project, with ~3,000 Ruby files in it:

```
$ find . -name '*\.rb' | wc -l
  2757
```

## Conclusion

For *my* use case, it seems clear that `rg` performs faster than `ag`. Don't take my word for it, though. Run a benchamrk yourself!
