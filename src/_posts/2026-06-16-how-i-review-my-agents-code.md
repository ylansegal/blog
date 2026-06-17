---
layout: post
title: How I Review My Agents' Code
date: 2026-06-16 17:14:24.000000000 -07:00
categories:
- machine_learning
- productivity
excerpt_separator: "<!-- more -->"
syndication_excerpt: 'Coding agents changed my workflow: I now give code-review-style
  feedback many times a day. I dropped the copy-paste shuffle for revdiff, a TUI made
  for annotating diffs and plans.'
syndicated:
- platform: bluesky
  url: https://bsky.app/profile/ylan.segal-family.com/post/3moh2ot572a2f
  date: '2026-06-16 17:30:11 -0700'
---

Coding agents have changed how I work. I now give code-review-style feedback to agents many times a day.

In the before times, I used `git diff main...` to review my own changes locally before pushing to GitHub. As I noticed things, I wrote a todo list for myself to address. Rinse and repeat.

These days that feedback goes to an agent, not to my own todo list. I used to copy-paste file names and code snippets into the chat, but that gets old and verbose fast. Now I use [revdiff](https://revdiff.com/), a TUI built specifically for giving feedback to agents.

## Giving Feedback on Diffs

At its heart, `revdiff` opens a TUI that shows you changes in files. As you navigate, press `return` to write a comment on a line (or several). When you're done, press `q` and the program prints your comments in the context of the lines they apply to. From their own example:

```
## handler.go (file-level)
consider splitting this file into smaller modules

## handler.go:43 (+)
use errors.Is() instead of direct comparison

## handler.go:43-67 (+)
refactor this hunk to reduce nesting

## store.go:18 (-)
don't remove this validation
```

I review code before every commit, to catch issues as early as possible. The default `revdiff` invocation shows unstaged changes. It fits my workflow exactly.

You can also pass `git` ranges: `revdiff main...`, `revdiff branch-1...branch-2`, and so on. That's especially helpful for reviewing a whole branch.

## Giving Feedback on Plans

I have the agent write specs and plans first. That alone produces much better code (I use [superpowers](https://github.com/obra/superpowers)). I want to give feedback on those plans, but they aren't diffs of anything, and most of the time I don't even put them under source control. `revdiff` has me covered: `revdiff --only path/to/plan.md` opens the same feedback mechanism, with table-of-contents support for markdown. It beats what I did before: opening the file in my editor, adding comments prefixed with `--->` (or similar), then telling the agent to go find them.

## No Skill

`revdiff` ships with a skill that opens the feedback for you in an overlay window, supporting many different setups. I haven't needed it. Because I have my agent set up to prompt me before committing any code, I get a yes/no question when it's time to review a diff. I find it easy to switch to another terminal window, fire up `revdiff`, give feedback, and switch back. Then I accept the changes, or select no and paste the output. The skill would require me to stop the agent just to invoke it.

## Copy to Clipboard on Exit

Shuttling output between windows by hand added friction, so I automated copying the revdiff output to my clipboard every time. My [fish shell](https://fishshell.com/) configuration:

```
function revdiff --description "Run revdiff and copy annotations to clipboard"
    set -l tmp (mktemp /tmp/revdiff.XXXXXX)
    command revdiff --output=$tmp $argv
    and cat $tmp
    and pbcopy < $tmp
    rm -f $tmp
end
```

I don't worry about overriding my clipboard, because I use a [Raycast](https://www.raycast.com)'s clipboard manager.

## Config Tweaks

Lastly, I've tweaked the configuration:

```
$ cat ~/.config/revdiff/config
theme = nord
cross-file-hunks = true
compact = true
```

I can't say enough good things about the [Nord theme](https://www.nordtheme.com) in dark mode.

## Conclusion

`revdiff` has been an immediate productivity boost. I use it many times a day, and it has made interacting with agents much easier.
