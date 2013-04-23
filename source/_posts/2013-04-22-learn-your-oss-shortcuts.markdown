---
layout: post
title: "Forget Vim: Learn Your OS' Shortcuts For Productivity"
date: 2013-04-22 21:43
comments: true
categories:
- sublime_text_2
- productivity
---

I follow a certain number of ruby-related blogs and have noticed regular of calls to use Vim as an editor, usually with claims of unbridled productivity to follow. One one hand, I see the appeal: I use a bunch of UNIX tools and scripts in my daily work-flow and it makes sense to use a editor that works inside my terminal. I have tried a few tutorials, screen casts and what not, but I have never felt really comfortable. Something has always been off. I always assumed it was due to the big learning curve others talk about.

On the other hand, when I switched from TextMate to Sublime Text, there was almost no drop in productivity. Part of it has to do with similar functionality being mapped to the same keys, like command-t. However, I believe that there is more to it.

<!-- more -->

## Modes

Vim operates on a different paradigm than any other text editing application out there: It has modes. Normal. Insert. Command. It is the source of it's power, it is said. That may be. It is also one the biggest barriers: Every other place on my computer were text is entered and edited works in a different manner. You just enter the writing area, and type. This works for my email client, my word processor, my spreadsheet, my chat client, my terminal and all the places that my browsers takes me.

In addition, OS X provides lots of shortcuts that work *across* all these applications. Want to delete the last character? Hit [delete]. Want to delete the last word? [option]-[delete]. Delete the whole line? [command]-[delete]. It works everywhere. On Sublime Text, on Email, on JIRA. If you learn Vim's particular key combinations, it makes you more efficient in Vim. Learning the *universal* shortcuts make you more efficient everywhere.

## Shortcuts You Should Learn

For shortcuts to be learned and become second nature, they need to be repeated. The following are the keyboard shortcuts that I have accrued over the years and recommend for others to master:

| Command            | Action                                  |  
| ---------          | --------                                |  
| [command]-[x]      | Cut selection                           |  
| [command]-[c]      | Copy selection                          |  
| [command]-[v]      | Paste selection                         |  
| [command]-[z]      | Undo last operation                     |  
| [delete]           | Delete selection or preceding character |  
| [option]-[delete]  | Delete preceding word                   |  
| [command]-[delete] | Delete until beginning of line          |  
| [→]                | Move one character to the right         |  
| [←]                | Move one character to the left          |  
| [↑]                | Move on line up                         |  
| [↓]                | Move on line down                       |  
| [option]-[→]       | Move one word to the right              |  
| [option]-[←]       | Move one word to the left               |  
| [option]-[↑]       | Move to beginning of text area or file  |  
| [option]-[↓]       | Move to end of text area or file        |  
| [command]-[→]      | Move to end of line                     |  
| [command]-[←]      | Move to beginning of line               |  

---

The last 6 commands can be modified by with [shift] to expand the selection. 

Of course, I do use a few editor-specific shortcuts, but I prefer OS shortcuts when available, even if it means an extra keystroke. For example, in Sublime Text if you have no selection, typing [command]-[x] will cut the whole line, effectively deleting it. However, this trick does not work everywhere else. Instead, I use [command]-[delete], [delete] which deletes the whole line, and then the carriage return.

Some of the Sublime Text 2 shortcuts that I can't live without: 

| Command       | Action                                         |  
| ---------     | --------                                       |  
| [command]-[t] | Fuzzy file search                              |  
| [command]-[p] | Fuzzy command search                           |  
| [command]-[/] | Comment / Uncomment current line               |  
| [command]-[.] | Switch to test / main file (from Rspec plugin) |  

Note that because of their nature, I am not likely to reach for these commands when editing text that is not code related, like an email, so they don't really cause any dissonance.


## Making iTerm 2 Play Along

I mentioned UNIX tools: I spend a decent amount of my time in iTerm. I use git's command line client (with a few aliases of course), usually run my specs from the database, debug data in my database shell, etc. Most of the above shortcuts don't work there as ```bash``` and ```zsh``` have their own key bindings. However, it is not hard to have iTerm do the translation for you: In the preferences, you can map a keyboard shortcut to hex codes. Most of the bash standard shortcuts map directly to one of those. 

For example, I added a shortcut for [command]-[←] to send hex code 0X15, which maps to [ctrl]-[a]. In turn, bash interprets this and moves your cursor to the beginning of the line. So far, here are the mappings I have added:

| Shortcut           | Hex Code to Map To   |  
| ----------         | -------------------- |  
| [command]-[→]      | 0X05                 |  
| [command]-[←]      | 0X01                 |  
| [command]-[delete] | 0X15                 |  
| [option]-[delete]  | 0X17                 |  
---

You can augment by checking the [ASCII Reference][1]

## Conclusion

Software Engineers spend a great deal of their time writing and editing text, but a non-trivial amount is done outside your main editor or IDE. We write many emails, type on chat windows, use our browser for issue tracking. Your OS already provides a lot of keyboard shortcuts for dealing with text that is common to all these activities. By leveraging those were possible, as opposed to the application specific ones, you boost your productivity across the board and reduce contexts shifting.

[1]: http://www.csee.umbc.edu/portal/help/theory/ascii.txt