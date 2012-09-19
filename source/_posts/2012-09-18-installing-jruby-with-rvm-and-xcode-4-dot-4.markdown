---
layout: post
title: "Installing jruby with rvm and XCode 4.4"
date: 2012-09-18 21:23
comments: true
categories: 
- rvm
- jruby
- xcode
---

I recently setup a new Mac (running Lion) for development using jruby. As I have done many times in the past, I installed Xcode (4.4) and proceeded to install the command line tools. Next comes rvm, and we are humming along, until it complains that gcc-4.2 is not in my path. But it is. I can see it with ```gcc --version```. In any case, the notes for rvm suggest using [homebrew][1] to install gcc-4.2 like so:

```
brew update
brew tap homebrew/dupes
brew install autoconf automake apple-gcc42
rvm pkg install openssl
```

Since I use homebrew to install other packages anyway, this worked out fine.

That took care of my problem, and I proceeded to install jruby as usual:

```
rvm install jruby
```

[1]: http://mxcl.github.com/homebrew/