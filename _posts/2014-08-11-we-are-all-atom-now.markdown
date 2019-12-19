---
layout: post
title: "We Are All Atom Now"
date: 2014-08-11 08:24
comments: true
categories:
- productivity
- atom
---

Back in February [I wrote about Atom][1]. At the time, I felt Atom showed promise, but was still a bit lacking. After Github announced that Atom is now [completely open source][2] in May, I decided to take another look. Most of what I use every day for development is open source, especially the tools with which I make my living: Linux, zsh, Ruby, Rails, etc that I find the idea of my editor being open source very appealing.

### Code Navigation

Atom uses ctags, as does other Unix-y editors.[ Support for jumping back][3] from declarations has now been added, wich was crucial for my workflow. Another issue I had was the lack of context when multiple symbols were listed when navigating, but I managed to wrestle my way through coffeescript [to fix that][4]. Now, it works just like I expect it to.

### Speed

Atom has much better performance now and it is clear that the development team consider this a priority. Overall, I find that the speed while working in the editor (opening files, editing files, jumping between files, searching) is acceptable and I do not notice and lag. Opening the editor, however is another matter. It is very sluggish, even when opening directories that are not deep and with a small number of files. For example, I enjoy using Atom for my git commit messages since I am already familiar with the navigation and it has a nice syntax formatting. However, some times it takes several seconds to open and makes me want to tear my hair out.

### Contributing

Being open source means any one can download the source and hack, but Atom makes it much easier than that. The guide explains how to create new packages for atom and it includes a testing framework out-of-the-box. I had never written a line of coffescript (or much javascript for that matter) and was able to use `apm` to download a package, make a few fixes and submit a pull request: I can see why there is so much excitement about Atom.

### Conclusions

I have been using Atom as my main editor for the last 3 months. For being a beta version, I find the editor more than usable. Sublime Text 2 is a great editor and a lot of Atom is modeled after it (just as Sublime is modeled after TextMate). However, I believe Atom is here to stay and is my main editor for the foreseeable future.

[1]: /blog/2014/02/28/must-have-editor-features/
[2]: https://github.com/blog/1831-atom-free-and-open-source-for-everyone
[3]: https://github.com/atom/symbols-view/pull/27
[4]: https://github.com/atom/symbols-view/pull/28
