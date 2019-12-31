---
layout: post
title: "Use Multiple Ruby Engines In The Same Project"
date: 2014-04-04 14:32
comments: true
categories: 
- ruby
- bundler
---

One of the biggest pains of using jruby is the slow startup time. 

For a trivial rails application, the startup is really painful:

``` bash
$ rvm current
jruby-1.7.11
$ time rails runner "puts 'Hello'"
Hello
rails runner "puts 'Hello'"  24.82s user 0.83s system 223% cpu 11.457 total
```

Compare to the same project running MRI:

``` bash
$ rvm current
ruby-2.1.1
$ time rails runner "puts 'Hello'"
Hello
rails runner "puts 'Hello'"  1.14s user 0.19s system 98% cpu 1.355 total
```

MRI is more than 20 times faster!

<!-- more -->

# If You Can't Ditch jRuby...

Because of deployment constraints and a small portion of the application depending on java classes, ditching jRuby altogether is not an option. However, having a fast TDD loop is essential, which is hard to do with startup times of more than 20 seconds. What if we could run individual specs in MRI and our integration specs and server in jRuby?

## Platform specific gems in Bundler

Bundler supports specifying a platform when defining a gem, which allows to write a `Gemfile` like:

``` ruby Gemfile
source 'https://rubygems.org'

gem "rails", "4.0.4"
gem 'sass-rails', '~> 4.0.0'

platform :ruby do
  gem "pg", "~> 0.17.1"
end

platform :jruby do
  gem 'activerecord-jdbc-adapter'
  gem 'activerecord-jdbcpostgresql-adapter'
  gem 'trinidad'
end
```

This syntax allows us to run `bundle install` on each platform and generate a `Gemfile.lock` file. For simple projects, this approach is sufficient and one can switch rubies with no adverse effects.

However, for more complex projects the generated `Gemfile.lock` for each platform is not the same, due to the fact that there are some platform specific gems being installed. In general, if you intend to add your `Gemfile.lock` file (and you should in a Rails application), then this will cause your repo to be dirty constantly and endlessly having to delete the existing Gemfile.lock when changing rubies. Hardly ideal. 

## Multiple Gemfiles, But Not Really

Bundler also has support for using an environment variable `BUNDLE_GEMFILE` for determining which Gemfile to use. In combination with some hackery, it make it possible to use the same `Gemfile` but have platform specific lock files. 

``` ruby Gemfile.mri
eval File.read('Gemfile')
```

In order to start using mri for our project (jruby is the default):

``` bash
$ export BUNDLE_GEMFILE=Gemfile.mri
$ rvm use ruby
```

Now, that shell is ready to roar and there is no interference in the `Gemfile.lock`. 

The difference between the lock files locks like this:

``` bash
$ diff -h Gemfile.lock Gemfile.mri.lock
38a39
>     atomic (1.1.16)
45c46
<     jruby-rack (1.1.13.1)
---
>     jruby-rack (1.1.14)
51a53
>     pg (0.17.1)
85a88,89
>     thread_safe (0.3.1)
>       atomic (>= 1.1.7, < 2)
92,95c96,99
<     trinidad (1.4.4)
<       jruby-rack (>= 1.1.10)
<       trinidad_jars (>= 1.1.0)
<     trinidad_jars (1.3.0)
---
>     trinidad (1.4.6)
>       jruby-rack (~> 1.1.13)
>       trinidad_jars (>= 1.3.0, < 1.5.0)
>     trinidad_jars (1.4.0)
99a104
>   ruby
```
