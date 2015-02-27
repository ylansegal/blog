---
layout: post
title: "Experiment: Use RSpec Expectation Syntax"
date: 2015-02-26 20:13:14 -0800
comments: true
categories:
- experiment
- rspec
---

A few months ago, the RSpec team [announced][1] the new expectation syntax. In the simplest form, the old way of saying:

``` ruby
foo.should eq(bar)
foo.should_not eq(bar)
```

is now:

``` ruby
expect(foo).to eq(bar)
expect(foo).not_to eq(bar)
```

Most of my work is on a long-running project with an extensive test suite. It has over 8,000 should statements in it:

``` bash
$ ag '\.should' spec | wc -l
    8097
```

This personal experiment is a simple one: Stop using `should`. Use `expect`.

The motivation for the experiment is to not be left behind. The writing is on the wall. Although the RSpec team has not announced the deprecation of the `should` syntax, it is clear that the prefer the `expect` syntax and believe this is the way forward.

## Methodology

For the last two weeks, I have been writing all new specs exclusively with the `expect` syntax. At this point, I have made no effort to change all existing uses of `should`. I have always liked the `should` syntax for its expressiveness, which I suspected was lacking in `expect`.

## Results

I was pleasantly surprised. At first, I found myself immediately reaching for my trusted `should`. Pretty quickly `expect` started to become second nature. I still believe that `should` is bit more expressive when reading complete lines of code. However, `expect` does have an advantage: It is usually at the beginning of the line, which makes it obvious which lines are setup for the example and which are the expectations or assertions.

## Going Forward

`expect` is in, `should` is out for all new specs. There is no immediate intention to convert wholly to `expect` because the project is large and we can't immediately move to RSpec 3.x branch anyway (becuause of a conflict with another gem). That will need to come at a later time. In the meantime, we can start converting file by file as we touch them and do the work piecemeal.

[1]: http://rspec.info/blog/2012/06/rspecs-new-expectation-syntax/
