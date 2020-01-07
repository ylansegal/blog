---
layout: post
title: "The REPL: Issue 21 - April 2016"
date: 2016-05-02 09:15:48 -0700
comments: true
categories:
- the rep
excerpt_separator: <!-- more -->
---

### [The Optimist’s Guide to Pessimistic Library Versioning][1]

Richard Schneeman, writes a well though out post on library versioning. He [previously][4] wrote about Semver and now continues on that vein with how it applies in practice for library authors and users. The key take-away is that adhering to Semver and the widespread use of optimistic locking can alleviate a great deal of the pain of maintaining and upgrading dependencies for projects.

### [Detecting the use of "curl | bash" server side][2]

Internet security is fascinating. I have read advise that before using `curl` to download a file and piping directly to `bash`, you must ensure that you know what you are downloading. However, as this post proves, looking at the URL in your browser is not enough. By using a clever trick to detect how data is being pulled from a server, an attacker can present different content when URL is being downloaded and piped to `bash`. Security is hard. Really Hard.

### [Git history is underrated][3]

Author's thoughts on what a project's log of commit messages are: A history of _why_ the code in the repository is the way it is. For the reasons outlined, I prefer never to squash commits when merging.


[1]: https://blog.codeship.com/optimists-guide-pessimistic-library-versioning/
[2]: https://www.idontplaydarts.com/2016/04/detecting-curl-pipe-bash-server-side/
[3]: http://eftimov.net/git-history-is-underrated
[4]: http://www.schneems.com/2015/11/29/what-is-semver.html
