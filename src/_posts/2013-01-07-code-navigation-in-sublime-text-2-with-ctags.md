---
layout: post
title: "Code Navigation in Sublime Text 2 With CTags"
date: 2013-01-07 16:55
comments: true
categories:
- sublime_text_2
- ctags
- most_popular
---

Do you want to have a shortcut that takes you from a method call to it's definition, wherever that may be in your code?
How about another shortcut to jump back to your previous position. Here is how to do it in [Sublime Text 2][1]

<!-- more -->

This magic is made possible by [CTags][2] and the awesome [Sublime Text 2 Plug-In][3].

> Ctags generates an index (or tag) file of language objects found in source files that allows these items to be quickly and easily located by a text editor or other utility. A tag signifies a language object for which an index entry is available (or, alternatively, the index entry created for that object).

## Installation

Installation is easy, you need to install ctags first (platform dependent, but easy if you follow the [README][3]) and
to install the plugin, you can use [Package Control][4].

## Customization

The current project I am working on is pretty big, but I am not interested in having ctags for all the project, since
I am just working on the ruby stuff and none of the JavaScript. Thus, to make ctags more accurate, I customized the
way the tags are generated to only include ruby files and to include the gems in use in that project.

First, I created a shell script in my path called ```ctags_for_ruby```

```ruby
#!/usr/bin/env ruby

# Generate project ctags
system("find . -name '*.rb' | ctags -f .tags -L -")

# Generate gem ctags
if File.exist?('./Gemfile')
  require 'bundler'
  paths = Bundler.load.specs.map(&:full_gem_path).join(' ')
  system("ctags -R -f .gemtags #{paths}")
end
```
Now, we configure the plugin to use this script to create the tags:

``` json Preferences -> Package Setttings ->  CTags -> Settings - User
{
    "command"   :  "ctags_for_ruby"
}
```

By default, the plug-in will look for ```tags```, ```.tags``` and ```.gemtags``` in the project directory.

## Enjoy

That is it, use the plug-ins keyboard shortcuts (or override) and navigate to method definitions (ctrl+t ctrl+t) and
back (ctrl+t ctrl+b) or rebuild (ctrl+t ctrl+r) as needed.

After just a few days of using it, I found it indispensable.

[1]: http://www.sublimetext.com/
[2]: http://ctags.sourceforge.net/
[3]: https://github.com/SublimeText/CTags
[4]: http://wbond.net/sublime_packages/package_control
