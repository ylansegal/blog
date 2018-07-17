---
layout: post
title: "On Taking Notes"
date: 2018-07-17 13:44:13 -0700
comments: true
categories:
  - productivity
published: false
---

For the last year, I've been keeping detailed notes of my daily work as a software engineer. It has been a worthwhile experiment. My notes have become and integral part of my process.

# How I Take Notes

For my note taking, I chose to use my text editor of choice (currently Atom, but that is not the point). I spend a lot of my time editing and reading code inside my text editor. I am familiar with it's UI and it's capabilities. It was a natural choice to use. I take my notes in [Markdown][markdown]. In particular I use [GitHub's variant][gh-markdown]. It supports what I now consider must-haves: Code block syntax highlighting and checklist functionality.

My notes are saved into a dedicated directory on my computer. Synching to the cloud, for backup or to use in other devices is accomplished by any synching service already installed: Dropbox, iCloud, Google Drive, etc. It doesn't really matter which one. Plain text files use very little space, they are almost immediately uploaded as soon as they are saved. File size quotas are not a problem.

## My Daily Note

One of the first tasks I do every work morning, is create a new note with the date as it's file name (eg. `~/Notes/Daily/2018-07-17.md`). I use ISO style dates, because they are lexically sorted as expected. This file serves as my daily board and scratchpad:

```md
# Next
- [ ] [[Work/RTF-1564]]: Research ActiveRecord::RecordNotFound in production
- [ ] [[Work/RTF-1567]]: Add instrumentation to controllers

# Waiting For
- [x] [[Work/RTF-1532]]: Bump nokogiri version in Gemfile

# Projects
- [ ] Learn about GenStage In Elixir
- [ ] Improve performance of slowest DB queries

---
```

Tasks that are in progress are preceeded by `- [ ]`. If needed, they can be nested. Tasks that have been completed are marked as `- [x]`. I generally keep few headings. `Next` are things that I intend to work on soon. `Waiting For` are things that I can't continue until something else happens: Feedback, code review, a deployment, etc. `Projects` is usually reserved for things that I want to keep on my radar, but are not necessarily time sensitive and can be done any time.

I've tried using more nuanced categorization, tags, and such. In general, I find that I don't really need it. My daily note usually doesn't contain more than 20 items in it. Some of the tasks have a notation in this format: `[[Work/RTF-1564]]:`. The RTF-1564 is the ticket number from the issue tracker at work. The `[[]]` are Wiki-style links. I use the [wikilink][wikilink] plugin to jump to a different file. Triggering the shortcut while the cursor is over `[[Work/RTF-1564]]`, will automatically create (if needed) and open the `RTF-1546.md` file in the `Work` folder. This allows me to create a detailed note for my work in that particular ticket and come back to it automatically.

During the day, I come back to my daily note often. I check-off completed tasks and add new ones as needed. At the start of the day, I create a new daily note. I copy all incomplete items from the last day, review and prioritize my day. I've created a small shell function that takes care of this for me:

```shell
today () {
	cd $HOME/Personal/Notes || return
	target_note="DailyLog/$(date '+%Y-%m-%d').md"
	if [ ! -f $target_note ]
	then
		last_note=$(find DailyLog | sort | tail -n 1)
		grep -v "\- \[[xX]\]" $last_note | awk 'NR == 1 { output = 1 }; /---/ { output = 0 }; output { print }' > $target_note
	fi
	atom . && atom $target_note
	cd - || return
}
```

The `awk` portion ensures that I only copy up to the first occurrence of `---` in the file. I use that as a separator. Below that, I use the daily note as a scratchpad for things that don't warrant a more detailed note.

## Detailed Work Notes

The previous section is mostly a home-grown personal productivity system. The only reason why I bother with it, is because it allows me to seamlessly jump to more detailed notes for tasks or projects. Inside these notes, is where most of my note taking takes place.

I usually start a task by writing down a summary of what I am supposed to do and what my assumptions are. Usually, putting down my assumptions triggers my creating a few tasks to validate some of those assumptions.

## Weekly Log

##

# Why I Take Notes

[markdown]:
[gh-markdown]:
[wikilink]: https://atom.io/packages/wikilink
---

- Format: markdown
- Tools: Text editor, aliases, etc.
- What I write down
- Benefits:
  - Like rubber ducking - writing down forces me to form concrete thoughts
  - Reference
  - Cements learning
