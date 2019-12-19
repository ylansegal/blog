---
layout: post
title: "Subtleties of xargs on Mac and Linux"
date: 2016-10-19 09:41:48 -0700
comments: true
categories:
- unix
---

`xargs` is one of my go-to tools in Unix. It reads lines from stdin and executes another command with each line as an argument. It's very useful to glue commands together.

It's default behavior is slightly different in Mac (or BSD) and Linux, in a subtle way. On the Mac, if there is no input from stdin, it will not execute the command. On Linux, it will execute it without any argument.

As an example, let's say that we want to use `rubocop` (a ruby syntax checker and linter) to check *only* RSpec files in a project. We can write something like this:

``` bash
$ find . -name '*_spec.rb' | xargs rubocop
```

On a project that has a two spec files, expanding the above example:

``` bash
$ find . -name '*_spec.rb'
./spec/one_spec.rb
./spec/two_spec.rb
```

 `xargs` will execute the equivalent of:

 ``` bash
 $ rubocop ./spec/one_spec.rb ./spec/two_spec.rb
 ```

---

The subtlety in behavior cames in when *no* files are found. To illustrate, let's see the difference in a trivial example:

``` bash
$ uname
Linux
$ echo "" | xargs echo "Hello"
Hello
```

``` bash
$ uname
Darwin
$ echo "" | xargs echo "Hello"
$
```

On Linux, `xargs` will execute the utility, on a Mac it will not. The Linux version can be configured to have the same behavior as the Mac:

```
$ uname
Linux
$ echo "" | xargs --no-run-if-empty echo "Hello"
$
```

Unfortunetly, the `--no-run-if-empty` option is not recognizable by the Mac:

```
$ uname
Darwin
$ echo "" | xargs --no-run-if-empty echo "Hello"
xargs: illegal option
usage: xargs [-0opt] [-E eofstr] [-I replstr [-R replacements]] [-J replstr]
             [-L number] [-n number [-x]] [-P maxprocs] [-s size]
             [utility [argument ...]]
```

Why is this important? In the original example, if no files are found, `rubocop` will not be invoked at all on the Mac, but will be invoked with no arguments on Linux. In my case, that is unwanted behavior because rubocop will then check all files in the project.


# Conclusion

When writing `bash` scripts that are intended to run on different Unix version, be careful that you understand and test the behavior of the Unix commands used, sometimes they have subtle differences in behavior.
