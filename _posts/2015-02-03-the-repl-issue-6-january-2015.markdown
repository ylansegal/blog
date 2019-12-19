---
layout: post
title: "The REPL: Issue 6 - January 2015"
date: 2015-02-03 08:53:47 -0800
comments: true
categories:
- the repl
---

The REPL is a monthly feature in which I pick my favorite content from around the web, read, but not necessarily published, in the last month. Most of it is technology related.

### [Suspicions of nil][1]

In her usual eloquent and clear way, Sandi Metz explores the issue with passing `nil` around as a return value from other objects. She shows a few of the pitfalls and type checking necessary to deal with the complexity. I'm looking forward to the promised sequel, billed to explore the Null Object pattern.

### [Command-line tools can be 235x faster than your Hadoop cluster][2]

Adam Drake explores traditional Unix tools to analyze a large data set. Using `cat`, `find`, `xargs` and `awk` he shows that performance can be much better than that used by a Hadoop cluster. The comparison is based on results from another post, which I could not find, since the link seems to have gone away. Nonetheless, I think the the point is made abundantly: Before jumping on the latest shinny big-data thing, it's probably a good idea to try the tools already installed in your server.

### [Myron Marston's Response To Tenderlove][3]

Tenderlove posted a review with [his experience with MiniTest and RSpec][4]. Myron [responded][3] to some of the issues addressed. I found both articles good reads. I have used both frameworks extensively and I am personally partial to RSpec. However, I applaud Tenderlove and Myron for their posts and the decorum which they exhibited. It is quite common for online back and forth to descend into personal insults quite fast. This is not the case. In the course of the discussion, I also learned a thing or to about both frameworks.

### [Pairing with Junior Developers][5]

Sara Mei writes an excellent piece about how senior developers can make the most out of pairing with junior ones, with better results for both developers. I personally don't pair at work all the time, but I found that most of the content is applicable not only to pairing, but working with junior developers in general. As with most things, you get more out of it if you are dedicated and mindful.

[1]: http://www.sandimetz.com/blog/2014/12/19/suspicions-of-nil
[2]: http://aadrake.com/command-line-tools-can-be-235x-faster-than-your-hadoop-cluster.html
[3]: https://gist.github.com/myronmarston/9c21b85c784871161d36
[4]: http://tenderlovemaking.com/2015/01/23/my-experience-with-minitest-and-rspec.html
[5]: https://devmynd.com/blog/2015-1-pairing-with-junior-developers
