---
layout: post
title: "Code spelunking with rg and join"
date: 2021-08-13 10:49:37 -0700
categories:
- unix
excerpt_separator: <!-- more -->
---

The power of the [unix philosphy](https://en.wikipedia.org/wiki/Unix_philosophy) is that you can compose single-purpose tools together, to great effect. For example, let's say we are working on a Rails app. We want  to find all controllers that use `current_user`, and also inherit from `ApplicationContrller`.

I would run the following:

```
$ join \
 <(rg '< ApplicationController' app/controllers --files-with-matches | sort) \
 <(rg 'current_user' app/controllers --files-with-matches | sort)
```

Let's break it down.

```
$ rg '< ApplicationController' app/controllers --files-with-matches
app/controllers/pdfs_controller.rb
app/controllers/language_selection_controller.rb
app/controllers/info/pages_controller.rb
app/controllers/secure/base_controller.rb
```

[ripgrep](https://github.com/BurntSushi/ripgrep) (`rg`) is an excellent replacement for `grep`: It searches the content of files for a matching regex. The expression above searches for the regex `< ApplicationController` to find classes inheriting from `ApplicationController` inside the `app/controllers` directory. Like `grep`, `rg` can return both file, line number and match information. In this case, I am directing it only return filenames with `--files-with-matches`.

We now have a list of files in `app/controllers` that have classes inheriting from `ApplicationController`.

Next, we want to find uses of `current_user` in those files. There are a few ways we can accomplish that. I decided to find *all* controllers that use `current_user`, and later compare the two lists. The second list of files is found with:

```
$ rg 'current_user' app/controllers --files-with-matches
app/controllers/secure/password_resets_controller.rb
app/controllers/secure/medical_profiles_controller.rb
app/controllers/secure/bus_trips_controller.rb
app/controllers/secure/profiles_controller.rb
app/controllers/secure/signatures_controller.rb
app/controllers/secure/bus_reservations_controller.rb
app/controllers/secure/base_controller.rb
```

With the two lists in hand, we can then turn to `join`. From the `man` page:

> join -- relational database operator

> The join utility performs an ``equality join'' on the specified files and writes the result to the standard output.

Much like a `JOIN` in SQL which find corresponding records in two tables, `join` can find matching records in two files. Its usage typically requires specifying which field in each line to use for the join. Our usage is very simple though: Our lists of files only have a single field: The file name.

`join` expects two files as arguments. We could redirect the output of each of our `rg` calls to a file, and use those files as input to `join`. However, `bash` (and other shells too) allow for process substitution: It can take care of presenting the output of a subprocess to another process as if it was a file. That is done via the `<()` syntax, used twice: Once for each `rg` search.

The last bit is the usage of `sort`. `join` expects the files to be sorted:

> When the default field delimiter characters are used, the files to be joined should be ordered in the collating sequence of sort(1)

And there it is! We used `rg`, `sort`, `join`, and a bit of `bash` plumbing to find files that have lines matching two different regexes:

```
$ join \
 <(rg '< ApplicationController' app/controllers --files-with-matches | sort) \
 <(rg 'current_user' app/controllers --files-with-matches | sort)
app/controllers/secure/base_controller.rb
```
