---
layout: post
title: "Conway's Game Of Life"
date: 2013-07-16 12:06
comments: true
categories: 
- ruby
---

I recently read [a blog post recently][3] about Conway's Game Of Life: Since I had not written an implementation myself, I decided to give it a go. 

It was a fun exercise. I did not use any external library other than ruby's stdlib and used TDD for most of the classes. The interface uses curses. Not knowing how to test it, I took a page from Gary Bernhardt in [Functional Core, Imperative Shell][1] and didn't test the shell at all :)

Here it is: My Take on [Conway's Game Of Life][2]

[1]: https://www.destroyallsoftware.com/screencasts/catalog/functional-core-imperative-shell
[2]: https://github.com/ylansegal/game_of_life
[3]: http://devblog.avdi.org/2013/07/10/study-notes-conways-game-of-life-in-elixer/