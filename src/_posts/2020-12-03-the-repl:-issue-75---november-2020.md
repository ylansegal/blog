---
layout: post
title: "The REPL: Issue 75 - November 2020"
date: 2020-12-03 16:17:22 -0800
categories:
- the repl
excerpt_separator: <!-- more -->
---

### [Why Ruby Class Methods Resist Refactoring][1]

Sasha Rezvina explores why class methods in Ruby are hard to refactor. They tend to accumulate lots of logic. I prefer limiting class methods to "builder" methods that instantiate new objects, like `.initialize`.

### [Verbal Expressions: Ruby Regular Expressions made easy][2]

This looks like a fantastic library. It provides a way to "verbally" construct regular expressions:

```ruby
tester = VerEx.new do
  start_of_line
  find 'http'
  maybe 's'
  find '://'
  maybe 'www.'
  anything_but ' '
  end_of_line
end

tester =~ "https://www.google.com"
```

It supports string replacement, and capture groups too!

### [Moving my serverless project to Ruby on Rails][3]

This article illustrates one of my worries about the server-less trend: Each lambda function might be simple, but there interactions are not, and that is hard to reason about (and deploy!).

> When the building blocks are too simple, the complexity moves into the interaction between the blocks.


[1]: https://codeclimate.com/blog/why-ruby-class-methods-resist-refactoring/
[2]: https://github.com/ryan-endacott/verbal_expressions
[3]: https://frantic.im/back-to-rails
