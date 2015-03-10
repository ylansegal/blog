---
layout: post
title: "Fuzzy Match 'All-The-Things'"
date: 2015-03-09 08:49:28 -0700
comments: true
categories:
- unix
---

I started using fuzzy matching when I switched to Sublime Text 2 a few years ago (I currently use Atom, which also has the same feature built-in). The seemingly little improvement increased my productively greatly. It saves a few moments while opening files, but more importantly it prevents [context switching][1]. It lets me start working with a file (usually prompted by knowing or wanting to know the contents of it) without needing to think about the location of that file.

{% blockquote Wikipedia %}
In computer science, approximate string matching (often colloquially referred to as fuzzy string searching) is the technique of finding strings that match a pattern approximately
{% endblockquote %}

Such functionality is useful outside of code editors. Thanks to Unix's modularity, general purpose fuzzy matches can accomplish a lot.

There are a few tools out there, but I found [`Selecta`][2] and [`Percol`][3] to be the more polished o the options. As far as I can tell, they are interchangeable, since they operate on `STDIN` and `STOUT` exclusively. I prefer `percol` on a day to day, because it has better support for the using the keyboard arrows for selection and it has colored output showing the matched portions. It is also full-screen. However, in terms of functionality, both perform equally well.

## Changing Projects

My most-common use case for fuzzy matching is changing to project directories. I generally work on a few different projects throughout the day, which reside on different parent directories in my home directories. I created an function `cdp` that will search common locations using `find` and pipe the results to the fuzzy matcher for filtering. The output then goes to `cd`.

``` bash
# .bashrc, .profile, .zshrc or other file sourced by the shel initialization
cdp () {
	cd $(find ~/Development ~/Personal -maxdepth 1 -type d | percol)
}
```

## Fuzz: Fuzzy Match Current Directory Contents

I find myself wanting to find a file in the current directory often. Copying, diffing, working with git, running tests, etc. I created a general-purpose finder that uses `find` to find all files below the current directory, excluding those in directories starting with `.`. In addition it can be passed an argument to pre-filter for a string, which I only used on very large projects where `find` would take a long time to complete and make the fuzzy matching excessively slow.

``` bash
# .bashrc, .profile, .zshrc or other file sourced by the shel initialization
fuzz () {
	search_term=$1
	find . -wholename \*$search_term\* -not -path './.*/*' | percol
}
```

## `zsh` biding for ^S

The culmination of all this, comes by binding `^S` on my `zsh` shell to run `fuzz`. This allows me to run `fuzz` while writing arguments to a command already started on the command line and once the fuzzy match is done, returning control to the shell with the argument in place. This allows me to use fuzzy matching on-demand, for any command, across my shell. It has quickly become a tool I reach for throughout the day.

``` bash
# Only for zsh
# ^S for fuzzy matching
# By default, ^S freezes terminal output and ^Q resumes it. Disable that so
# that those keys can be used for other things.
unsetopt flowcontrol
# Run Selecta in the current working directory, appending the selected path, if
# any, to the current command.
function insert-fuzzy-path-in-command-line() {
    local selected_path
    # Print a newline or we'll clobber the old prompt.
    echo
    # Find the path; abort if the user doesn't select anything.
    selected_path=$(fuzz) || return
    # Append the selection to the current command buffer.
    eval 'LBUFFER="$LBUFFER$selected_path"'
    # Redraw the prompt since Selecta has drawn several new lines of text.
    zle reset-prompt
}
# Create the zle widget
zle -N insert-fuzzy-path-in-command-line
# Bind the key to the newly created widget
bindkey "^S" "insert-fuzzy-path-in-command-line"
```

It is worth noting that most of this ideas where obtained directly from the [Selecta README][2]. Thanks Gary Bernhardt!

---

*UPDATE (03/10/2015)*: A new project was [just announced][4] that has another interchangeable fuzzy picker utility, [pick][4]. This one is written in C, so it promises to be faster. More importantly, the project shows some more [fantastic ideas][5] on where to leverage fuzzy matching.

[1]: http://www.joelonsoftware.com/articles/fog0000000022.html
[2]: https://github.com/garybernhardt/selecta
[3]: https://github.com/mooz/percol
[4]: https://robots.thoughtbot.com/announcing-pick
[5]: https://github.com/thoughtbot/pick
