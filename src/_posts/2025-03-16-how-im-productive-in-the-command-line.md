---
layout: post
title: "How I'm Productive In The Command Line"
date: 2025-03-16 12:25:42 -0700
categories:
- unix
- productivity
excerpt_separator: <!-- more -->
---

I spend a lot of time on the command line. My most frequently used commands are `git` (by far), and `rails` (mostly for `rails test`) or `rspec` (depending on the project). Most invocation of both commands require arguments. And most of those arguments are paths to files. In big projects, typing paths to files can be tedious, even with <kbd>tab</kbd> completion. My productivity trick for that is using [Zsh Line Editor][zle] widgets.

Let's see a widget in action:

<video width="100%" controls>
  <source src="/assets/videos/widget_demo_1.mov" type="video/mp4">
</video>

<!-- more -->

What happened?
- I typed <kbd>rspec </kbd>, the command I want to run.
- I typed <kbd>ctrl+s</kbd> to bring up an interactive fuzzy file searcher
- I types a few keystrokes to narrow down the list of files in the project.
- I used my arrows keys to select the file I'm looking for (mostly for this demo)
- I typed <kbd>enter</kbd> to select the file and exit the fuzzy finder.
- Now I am back on the command line with `rspec spec/models/user_spec.rb` as the input
- One more <kbd>enter</kbd> to execute the command.

I find that workflow to be a productivity booster, almost like magic. I can start typing a command, jump to an interactive program to select arguments, and finish composing the command. File names are very common command line arguments, but not the only ones. I'll come back to that later.

The zle widget you saw is a bit of `zsh` configuration that I put in my `~/.zshrc` file:

```zsh
# ^S for fuzzy matching files under current directory
# By default, ^S freezes terminal output and ^Q resumes it. Disable that so
# that those keys can be used for other things.
unsetopt flowcontrol
# Run fuzz in the current working directory, appending the selected path, if
# any, to the current command.
function insert-fuzzy-path-in-command-line() {
    local selected_path
    # Print a newline or we'll clobber the old prompt.
    echo
    # Find the path; abort if the user doesn't select anything.
    selected_path=$(fd --strip-cwd-prefix | fzf --multi --scheme=path | xargs echo) || return
    # Append the selection to the current command buffer.
    eval 'LBUFFER="$LBUFFER$selected_path"'
    # Redraw the prompt since fzf has drawn several new lines of text.
    zle reset-prompt
}
# Create the zle widget
zle -N insert-fuzzy-path-in-command-line
# Bind the key to the newly created widget
bindkey "^s" "insert-fuzzy-path-in-command-line"
```

The comments tell most of the story: A zle widget is defined by a function, and it can be bound to whatever keyboard shortcut suits you fancy. I choose <kbd>ctrl+s</kbd> because I think of this widget as "search". The function itself, spawns another zsh shell `$(...)` that executes a pipe of commands.

[fd][fd] to list all files in the project, very quickly. Think of it as a replacement for `find`:

```
❯ fd --strip-cwd-prefix
vendor/
tmp/
tmp/.keep
postcss.config.js
Procfile
Gemfile.lock
log/
log/.keep
Gemfile
db/
# ... much more output
```

That is piped to [fzf](https://github.com/junegunn/fzf) is what is doing the heavy lifting. It bills itself as a general-purpose command-line fuzzy-finder:

> It's an interactive filter program for any kind of list; files, command history, processes, hostnames, bookmarks, git commits, etc. It implements a "fuzzy" matching algorithm, so you can quickly type in patterns with omitted characters and still get the results you want.

In this zle widget, I am using it to filter the list that `fd` provides (all files in the project). Note the `--multi` which allows selecting more than one file. Sometimes you need more than one argument to a command. And that is where the `xargs echo` comes in: It turns a list of file names into an argument list.

With a bit of configuration I've can now quickly find files in any project, for any command that I am composing: `mv`, `cp`, `rails test`, `make`, etc.

### Other Widgets

Fuzzy finding all files in a project is useful, but what I use the most [^1] is searching for files modified by `git`. All my projects use `git`, and when I typically operate on a file (`git add`, `git reset`, `git restore`, `rspec`, `rails test`, etc), that file is dirty in `git`s point of view (i.e. it is a new file, or has been modifier). The number of dirty files is much lower than the total number of files, which makes the interactive selection **much** easier:

<video width="100%" controls>
  <source src="/assets/videos/widget_demo_2.mov" type="video/mp4">
</video>

We don't have to stop at files either. I use `git` branch names as arguments for `git switch`, `git rebase`, `git merge` often. So, I have a zle widget for branch names. Lastly, I have a zle widget to select commit hashes, a less common but useful use.

In summary:
- <kbd>ctrl+s</kbd>: Fuzzy search files in the current directory tree.
- <kbd>ctrl+g</kbd>: Fuzzy search `git` dirty files
- <kbd>ctrl+b</kbd>: Fuzzy search `git` branch names.
- <kbd>ctrl+k</kbd>: Fuzzy search commit history.

<details>
  <summary>
  Full source
  </summary>

{% highlight ruby %}
## ZLE WIDGETS
# ----------------------
# ^S for fuzzy matching files under current directory
# By default, ^S freezes terminal output and ^Q resumes it. Disable that so
# that those keys can be used for other things.
unsetopt flowcontrol
# Run fuzz in the current working directory, appending the selected path, if
# any, to the current command.
function insert-fuzzy-path-in-command-line() {
    local selected_path
    # Print a newline or we'll clobber the old prompt.
    echo
    # Find the path; abort if the user doesn't select anything.
    selected_path=$(fd --strip-cwd-prefix | fzf --multi --scheme=path | xargs echo) || return
    # Append the selection to the current command buffer.
    eval 'LBUFFER="$LBUFFER$selected_path"'
    # Redraw the prompt since fzf has drawn several new lines of text.
    zle reset-prompt
}
# Create the zle widget
zle -N insert-fuzzy-path-in-command-line
# Bind the key to the newly created widget
bindkey "^s" "insert-fuzzy-path-in-command-line"
# ----------------------

# ----------------------
# ^b for fuzzy matching git branches
# Run fuzz in the current working directory, appending the selected path, if
# any, to the current command.
function insert-fuzzy-git-branch-in-command-line() {
    local selected_path
    echo
    selected_path=$(git for-each-ref refs/heads --sort='-committerdate' | cut -d/ -f3- | fzf --multi | xargs echo) || return
    eval 'LBUFFER="$LBUFFER$selected_path"'
    zle reset-prompt
}
# Create the zle widget
zle -N insert-fuzzy-git-branch-in-command-line
# Bind the key to the newly created widget
bindkey "^b" "insert-fuzzy-git-branch-in-command-line"
# ----------------------

# ----------------------
# ^g for fuzzy matching git files
function insert-fuzzy-git-files-in-command-line() {
    local selected_path
    echo
    selected_path=$(git status --porcelain | fzf --multi --scheme=path | sed s/^...// | xargs echo) || return
    eval 'LBUFFER="$LBUFFER$selected_path"'
    zle reset-prompt
}
# Create the zle widget
zle -N insert-fuzzy-git-files-in-command-line
# Bind the key to the newly created widget
bindkey "^g" "insert-fuzzy-git-files-in-command-line"
# ----------------------

# ----------------------
# ^k for fuzzy matching git commits
function insert-fuzzy-git-commits-in-command-line() {
    local selected_path
    echo
    selected_path=$(git log --oneline --decorate --max-count=1000 --color=always | fzf --ansi | awk '{ print $1 }') || return
    eval 'LBUFFER="$LBUFFER$selected_path"'
    zle reset-prompt
}
# Create the zle widget
zle -N insert-fuzzy-git-commits-in-command-line
# Bind the key to the newly created widget
bindkey "^k" "insert-fuzzy-git-commits-in-command-line"
# ----------------------
{% endhighlight %}

</details>

### Conclusion

I've been using zle widgets for years very effectively. In true unix fashion, combining Zsh Line Editor, with `git`, `fzf`, `fd` and a couple of other text wrangling commands, adds up to a total that is much greater than its parts: A composable and generic way to specify arguments for any command. In fact, when I am in a shell that doesn't have these setup (e.g. docker container, ssh into a host) my zle widgets is what I miss the most.

[^1]: I think. I don't actually know which widget I spawn more often. I don't think that information is logged so I could analyze it. <span class="emoji">🤷🏻‍♂️<span>

[zle]: https://zsh.sourceforge.io/Guide/zshguide04.html
[fd]: https://github.com/sharkdp/fd
