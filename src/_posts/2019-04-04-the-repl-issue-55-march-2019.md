---
layout: post
title: "The REPL: Issue 55 - March 2019"
date: 2019-04-04 14:46:50 -0700
comments: true
categories:
- the rep
excerpt_separator: <!-- more -->
---

### [What causes Ruby memory bloat?][1]

Hongli Lai writes a provocative post about his research into Ruby memory bloat. Long-running Ruby process, typically grow in their memory usage over time. It's common to see Ruby servers being re-started once a day (like on Heroku) to avoid this very issue. In this post, the author proposes that the reason behind memory bloat is not memory fragmentation, like a lot of people in the community assume. Instead, he points to the memory allocator (`malloc`) not releasing memory. I am not very familiar with memory allocation, so I am left wondering if other languages that also use `malloc` suffer from the same issue as Ruby.

### [HIML][2]

Akira Matsuda released a new templating engine with a novel take. The standard template engine in Ruby is `ERB`. It's the default in Rails when rendering HTML. A user typically starts with HTML and sprinkles in special tags that get processed as ruby and replaced. HAML, is an alternative that was designed to avoid writing inline code in a web document. It always generates valid HTML, because it functions as a DSL. The down-side is that one must learn the new syntax. That is where HIML comes in: It produces valid HTML and provides some of the conveniences of HAML (e.g. autoclosing tags), but as intuitive as HTML and ERB.

```html
<section> <!-- This will auto-close! -->
  <div> <!-- As will this -->
    <%= post.content %> <!-- Standard way to interpolate ruby code -->
```

### [Defining a Distinguished Engineer][3]

Jess Frazelle explains the qualities that a distinguished engineer or technical fellow should exhibit. The list is solid and resonates with my views. My only bone to pick is with the often-repeated adage: *Have strong opinions, loosely held*. I don't think that is quite accurate. *Opinions held in strength proportional to the weight of the evidence* doesn't have the same ring to it. I understand if it doesn't catch on. Note that the actual description under the heading is spot on:

> They do not need to have opinions on everything, that would be pedantic. Technical leaders should be able to use their experience to help others succeed, while also empowering others to own solutions.

[1]: https://www.joyfulbikeshedding.com/blog/2019-03-14-what-causes-ruby-memory-bloat.html
[2]: https://github.com/amatsuda/himl/blob/master/README.md
[3]: https://blog.jessfraz.com/post/defining-a-distinguished-engineer/
