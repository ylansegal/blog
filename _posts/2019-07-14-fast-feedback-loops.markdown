---
layout: post
title: "Fast Feedback Loops"
date: 2019-07-14 12:35:37 -0700
comments: true
categories:
- productivity
- atom
- unix
---

One of the reasons that I love TDD, is that it promotes fast feedback. You write a line, execute the tests, and see what the results are. I write outside-in-TDD most of the time. Occasionally, I don't have a clear idea of what tests to write, or I am doing exploratory coding.

For example, lately I've found myself writing a fair amount of raw SQL queries (without an ORM). SQL is finicky, and produced notoriously hard-to-decipher errors. As a consequence, I like to build up SQL in small increments, and execute the work-in-progress statement often, to see it and its output alongside each other. My workflow looks something like this:

![IO Demo](/assets/videos/io_demo.mp4)

What is going on? I selected some SQL, executed in `psql`, and appended the commented-out output into the same selection. After inspection, I can change the statement and repeat.

## Why?

The benefit I get from this workflow is that I can iterate in small steps, get feedback on what the current code does, and continue accordingly. This workflow is heavily inspired by Ruby's [xmpfilter][xmp] or the newer [seeing_is_believing][sib]. Both tools take Ruby code as input, execute it, and then record all (or some) of the evaluated code as comments to the code.  

## How?

This workflow is made possible by leveraging the [pipe][pipe] Atom package. I [previously described it][pipe-post]. It allows sending the current selection in Atom to any Unix command (or series of piped commands) and replaces the selection with the output.

Building on top of that, I wanted a unix command (that I called `io`, for lack of imagination) that would output both the original input and the commented-out output:

```bash
#!/usr/bin/env bash
# Prints stdin and executes in the given program, commenting the output.

set -euo pipefail

# Determine which comment pattern to use
case $1 in
  psql)
    comment='-- ' ;;
  *)
    comment='# ' ;;
esac

grep -v "^$comment" /dev/stdin | tee >("$@" | sed "s/^/$comment/")
```

The case statement selects the correct comment prefix. It is customary in many Unix tools to treat a line starting with `#` as a comment. `psql` is different, in that it uses `-- ` prefix. I haven't needed support for anything else, but it's easily extendible.

The meat of the execution breaks down like this:

```bash
# Reads /dev/stdin and removes and lines starting with a comment
grep -v "^$comment" /dev/stdin

# The comment-less input, is now send to tee.
# tee will redirect the input to a file and to stdout.
| tee

# Instead of a file, we give tee a sub-shell as a file descriptor, using
# process substition.
>( )

# That subshell will execute the rest of the arguments passed to io
# as a command
"$@"

# the output is piped to sed, to add the comment prefix to every line
| sed "s/^/$comment/"
```

The result is that the final output is what we have been looking for: The original input without comments, plus the executed input with comments added.

From my point of view, this is a great example of the Unix philosophy: Composing utilities to create new functionality. I took advantage of the flexibility in [input/output redirection][redirection] and [process substitution][psub] to improve my development workflow.


[pipe]: https://atom.io/packages/pipe
[pipe-post]: /blog/2017/10/18/pipe-atom-text-into-any-command/
[xmp]: https://www.rubydoc.info/gems/rcodetools/0.8.5.0/Rcodetools/XMPFilter
[sib]: https://github.com/JoshCheek/seeing_is_believing
[psub]: https://www.linuxjournal.com/content/shell-process-redirection
[redirection]: https://www.linuxjournal.com/content/bash-input-redirection
