---
layout: post
title: "Run Changed Specs"
date: 2012-10-16 20:11
comments: true
categories: 
- unix
- rspec
---

I usually create a branch while working on a feature or bug. I found it helpful to add the following script to my path:

```
#! /bin/bash

git diff --name-only master..HEAD | grep 'spec.rb' | xargs rspec
```

It's quick and dirty, but effective. It asks git for a list of filenames that have changed in the current branch, 
filters them to find specs and runs them with rspec. 