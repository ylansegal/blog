---
layout: post
title: "Must-have Editor Features: An Atom Review"
date: 2014-02-28 09:23
comments: true
categories:
- productivity
- sublime_text_2
- atom
- most_popular
---

I got an invite for [Atom][1] yesterday. I spent a few hours using it, as opposed to [Sublime Text 2][2], my current editor of choice. Here are the features that I consider that my editor must-have and how Atom handles them.

<!-- more -->

### Text Navigation and Manipulation

Navigating text within the current file in your editor and manipulating that text efficiently is a basic need for software developers. Since I prefer to [use my OS's shortucts][3], instead of editor-specific ones, this was seamless.

There is one exception though: Multiple cursor selection ([command]-[d]). I use that very often. Luckily, Atom has the same functionality as Sublime.

### Opening Files

When you know what file you want, getting to it should be fast, and through your keyboard. Atom uses the same Sublime convention ([command]-[t]) for opening a fuzzy search. It seemed adequate, although it seems that I needed to type more characters to narrow down the options, as compared to Sublime.

### Command Execution

There is a certain amount of operations that I don't perform often enough to know the keyboard shortcut, but often enough that I don't want to click around in menus to find it. Atom has a command palette, similar to Sublime, where all commands are accessible with fuzzy search. This worked great.

### Code Navigation

I was really happy to see that code navigation (like jumping to class and method definition) is done through ctags. I [use it in sublime too][4]. However, it seems that the implementation is still lacking. For my large Rails app, it would sometimes go to definitions without problems and sometimes it would just not find a method definition, even for a unique name across the code-base. Sublime's plug-in handled it just fine with the same ctags file.

Additionally, it seems you can jump to a symbol definition, but not jump back. I find this essential.

The current ctgas support is lacking.

### Search The Project

The search capabilities are also very similar to Sublime (and bound to the same keys), but it does one thing better. When searching, the results are shown in a regular buffer (as in Sublime), but when you press enter on any line, it takes you to the file and line. In Sublime you can accomplish this with a separate shortcut, that *only* seems to work if you are at the beginning of the line. Atom's way is an improvement.

## Conclusion

Atom looks promising. It's very similar to Sublime Text, but currently has some deficiencies. It is to be expected from software that is still in private beta. The welcome screen hints at it being non-free after the beta period. With that in mind, I don't think I have seen a compelling reason to *switch* to atom just yet.


[1]: http://atom.io
[2]: http://www.sublimetext.com/
[3]: /blog/2013/04/22/forget-vim-learn-your-os-shortcuts/
[4]: /blog/2013/01/07/code-navigation-in-sublime-text-2-with-ctags/
