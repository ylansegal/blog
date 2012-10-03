---
layout: post
title: "Faster Rspec: Jruby, Spork and Nailgun"
date: 2012-10-02 20:32
comments: true
categories: 
- jruby
- spork
- rspec
---

Much has been said about Rails slow start-up time on large projects. It is especially painful when 
trying to do TDD and each test takes 30 seconds to run, mainly in startup time. 

As a consequence, there have been many attempts to pre-load the Rails environment and have it ready to test. I tested some options
and saved 25 seconds on each test run. 

<!-- more -->

The contenders for rails pre-loading are: [Spork][1], [Spin][2] and [Zeus][3]. (I will give a honorable mention to [tconsole][4], but unfortunately it's only
for Test::Unit, and my current project uses rspec). Spork works fine and integrates nicely with rspec by passing the --drb option, 
but it's intrusive: It requires you to make changes to your spec_helper.rb and decide what gets loaded once, what loads before each run, etc. 
It can cause subtle hard-to-catch issues, too.

Spin and Zeus are both unobtrusive, that is, your project doesn't have to change to use them. One of the things I hate about Spin is that the
output is on the console that started the server, not the console that ran the tests. Zeus is the newer kid on the block and looks fantastic. 
On my tests it's the faster of the 3 and it not only makes tests faster, but can start a rails console in a blink of an eye. Alas,  both Spin and
Zeus rely on the underlying system use of ```fork```. However, the jvm doesn't support ```fork``` because it's not available everywhere the jvm 
runs (Windows, I am looking at you).	 And since jruby runs on the jvm... Spork it is. 

Using Spork, a single test in my project went to running in 30 seconds, to running in 7. That is a marked improvement. However, we can do better. 

jruby ships with [Nailgun][5]:

{% blockquote  %}
Nailgun allows you to start up a single JVM as a background server process and toss it commands from a fast native client almost eliminating JRuby's annoyingly slow start up time.
{% endblockquote %}

That sound good to me. So, to run a single spec with both nailgun and Spork, I run something like this:

```
$ jruby --ng -S rspec --drb /path/to/spec
```

That shaves my test time to 5 seconds. Not bad at all. 

I don't want to type all that each time I run rspec, plus if either Spork or nailgun is not running, it will bomb. So here is a script 
that will **Do The Right Thing &trade;**. I named it smart_rspec and put it in my path:

``` 
#! /bin/bash

RSPEC="rspec"

# Looking for nailgun
lsof -i :2113 > /dev/null
if [ $? == 0 ]; then
	RSPEC="jruby --ng -S $RSPEC"
fi

# Looking for spork
lsof -i :8989 > /dev/null
if [ $? == 0 ]; then
	RSPEC="$RSPEC --drb"
fi

CMD="$RSPEC $@" 
echo $CMD
$CMD
```

It leverages the ```lsof``` to search for open ports, and changes the command appropriately. Enjoy.

[1]: https://github.com/sporkrb/spork
[2]: https://github.com/jstorimer/spin
[3]: https://github.com/burke/zeus
[4]: https://github.com/commondream/tconsole
[5]: http://kenai.com/projects/jruby/pages/JRubyWithNailgun