---
layout: post
title: "Switching to VS Code"
date: 2022-06-28 15:44:14 -0700
categories:
- atom
- vs_code
excerpt_separator: <!-- more -->
---

The GitHub blog recently announced [Atom's sunsetting][1]. It's been clear for a while that my text editor of choice was not receiving regular updates. It is now time to move on.

I first [reviewed Atom][2] in 2014, and switched to using is as my primary editor [a few months later][3]. I spend considerable amounts of time in my editor. I [don't believe in modal editors][4], and instead want to edit text with the same shortcuts that I use in my operating system.

I considered a few text editors, mainly from the list in the [Ruby on Rails Community Survey][5]. Among the things that I was looking for were a way to [pipe text][6] from the editor to any command, so I can have [fast feedback loops][7]. Most importantly, I've developed a habit of taking a [lot of notes][8] in a markdown, in a system of my own very heavily inspired by the [Zettelkasten Method][9].

To hit all those objectives, it was clear I needed an editor that has a robust plugin system and is widely used. That pretty much left [Sublime Text][10] and [VS Code][11] as options. Sublime Text 3 is fast, and overall a pleasant editing experience. I was very disappointed with the available plugins. It's [package repository][12] makes it very hard to know which packages are actually compatible with v3, and requires a lot of trial and error. I couldn't configure it to my liking.

VS Code proved to have a very extensive [marketplace][13] of extensions that supplied the functionality I wanted. After a few days using it and tweaking as I went along, I am feeling very at home using it. I expected the same slow performance that Atom exhibits because both use Electron. I was pleasantly surprised. VS Code is much faster opening files (both cold opening without the application loaded, and warm opening). What really made the switch easier, was configuring to use the Atom keyboard shortcuts via an existing extension.

As of today, the list of extension I am using are:
```
$ code --list-extensions
akamud.vscode-theme-onedark
ban.spellright
BriteSnow.vscode-toggle-quotes
cescript.markdown-formula
fabiospampinato.vscode-open-in-github
hatoo.markdown-toggle-task
kortina.vscode-markdown-notes
ms-vscode.atom-keybindings
rebornix.ruby
ryu1kn.edit-with-shell
sianglim.slim
TakumiI.markdowntable
Thadeu.vscode-run-rspec-file
wingrunr21.vscode-ruby
zhuangtongfa.material-theme
```

I expect to continue to refine my VS Code configuration, but I am at the point where I don't open Atom at all. In fact, I've uninstall it, because I was used to typing `atom ...` on the command line by force of habit. I am now retraining to type `code ...`.

[1]: https://github.blog/2022-06-08-sunsetting-atom/
[2]: {% post_url 2014-02-28-must-have-editor-features %}
[3]: {% post_url 2014-08-11-we-are-all-atom-now %}
[4]: {% post_url 2013-04-22-forget-vim-learn-your-os-shortcuts %}
[5]: https://rails-hosting.com/2022/#os-editors-servers
[6]: {% post_url 2017-10-18-pipe-atom-text-into-any-command %}
[7]: {% post_url 2019-07-14-fast-feedback-loops %}
[8]: {% post_url 2018-08-26-on-taking-notes %}
[9]: https://zettelkasten.de/introduction/
[10]: https://www.sublimetext.com/
[11]: https://code.visualstudio.com/
[12]: https://packagecontrol.io/
[13]: https://marketplace.visualstudio.com/VSCode