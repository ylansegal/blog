---
layout: post
title: "Enforcing Style"
date: 2016-12-22 16:03:13 -0800
comments: true
categories:
  - ruby
  - teams
---

Most programming languages provide some flexibility on what they consider valid syntax. Take a boring piece of code:

```ruby
def print(values:)
  values.each do |value|
    puts "[#{Time.now}] #{value} processed"
  end
end
```

In those four lines of Ruby code, there are plenty of style decisions. I used a keyword argument, but could easily have used a standard argument. I used parenthesis for the method definition, even if Ruby will parse the line just fine without them. I used a `do end` block, but could have used `{}`. I used 2 spaces for indentation. I used double-quoted strings with interpolated values.

A programming style guide makes explicit what you intend to adhere to. It's largely about esthetics: What *looks* like Ruby. What *feels* like Ruby. It can also be about semantics and conventions. I can't objectively defend all of my style preferences, because they are not objective. They are a balance between readability, efficiency, verbosity, etc. Don't mistake subjectivity with lack of value.

When team members work on the same code base, but use wildly different style, there is often an unspoken turf war in source files. Everyone makes changes in their own style. It can either results in inconsistencies that are unsatisfying and confusing, or constant noise in pull request that flip from style to style. More subtly, and more concerning, it can also cause team members to treat large portions of the code as someone else's problem. Lack of ownership can quickly deteriorate into dysfunction. I would characterize lack of a common style as a symptom of larger issues in team dynamics, not a cause.

The process of adding a style guide, *can* help resolve some of the underlying issues, by forcing the team to agree on something that is largely a matter of personal preference. The process should be inclusive and respectful of all team members. It will require compromise. The goal is to make a stronger team. Better looking code is nice, to.


## Creating Your Own Style Guide

Now that you have decided -- as a team -- to embark on creating a shared style guide, let's get to the details. First, creating a style guide can be a daunting. I recommend starting with the comprehensive [Ruby Style Guide][ruby_style_guide] maintained by Bozhidar Batsov. Start by forking the style guide into your own project. This will be the basis of the conversation for your team. Use the same tools you use to work as a team -- version control and pull requests.

At this point, the people work begins. Maybe you don't like sometimes using single-quoted strings and sometimes double-quoted strings. Or you think that 80 characters is ridiculous as a line-length-limit for modern screens. Maybe I think those things. In any case, the important part here is to start a civil, cordial conversation with your teammates on what conventions you want to follow and adopt as your own. Coming to an agreement and establishing ownership are the most important benefits of this whole exercise. Expect this process to take some time and to be include a good amount of bike shedding. A lot of these decisions are subjective and arguments for them are not much better than personal preference. Stick with it.

## Checking Style

Bozhidar Batsov also maintains an amazing gem called [rubcop][rubocop]. It's a static code analyzer, that seeks to enforce the contents of the [style guide][ruby_style_guide]. It includes many different "cops", each enforcing different aspects of the code. Examples are `Metrics/LineLength`, `Style/EmptyLines` or `Style/EmptyElse`. `rubocop` is highly configurable and extensible.

Your first step, is to run `rubocop` without any configuration in one of your projects. I recommend starting with a small project. `rubocop` is very opinionated and there are bound to be many offenses in any given source file.

```
$ rubocop --show-cops example.rb
Inspecting 1 file
C

Offenses:

example.rb:1:1: C: Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
"This is a line"
^^^^^^^^^^^^^^^^

1 file inspected, 1 offense detected
```

In this first phase, our goal is to hand-craft a configuration that reflects the text in your style guide. Because of that, I used the `--show-cops` option. It will show the name of the cop that is marking the offenses. Each cop can be configured (or disabled). Look in the excellent [documentation][rubocop_docs] for information on each one.

Once familiar with the syntax, you can start adding entries to a `.rubocop.yml` file in the project root directory. At this point, I don't recommend making any changes to source files to comply with cops. That will come later. A simple configuration, looks like this:

```
Metrics/LineLength:
  Max: 120

Style/StringLiterals:
  EnforcedStyle: double_quotes
```

### Auto-correcting

`rubocop` has the ability to auto-correct some of the cops. This helps with some of the tediousness of having to make many edits. I recommend running a single cop at a time with auto-correct. I find it easier to inspect the changes that way before committing, as well as smaller commits with better descriptions.

```
$ rubocop --auto-correct --only Style/StringLiterals
```

Ensure that you review your changes before committing. The last thing you want is to introduce bugs into your application. You do have a good test suite, right?

### Managing Large Code Bases

Sometimes, for very large projects, removing all style offenses can be a daunting tasks. `rubocop` allows you to declare a bankruptcy of sorts, to let you keep moving in the new direction. The idea is that current offenses will not be flagged, but new ones will. You can auto generates a "to do" file, that marks current violations and make a plan to address them later. For example, if editing a file in the future for a different reason, you can make a commitment to fix the style first, and then do the original work. That way, correcting the style becomes a part of the daily routine and not a larger-than-life tasks.

```
$ rubocop --auto-gen-config --exclude-limit 99999999
```

The above will generate a `.rubocop_todo.yml` with exclusions to current offenses. Using that file with `rubocop` will result in zero offenses, by definition. The `--exclude-limit` is set to a high number, so all exclusions are logged, instead of whole files being ignored. As with your regular `rubocop` config, this should be checked in to version control.

As you fix existing offenses, be sure to run `--auto-gen-config` to ratchet down the exclusions in your project. Decide with your team when the "ratcheting" will happen (e.g. on each pull request, once a week).

## Continuos Integration

You now have everything in place to enforce style on a project. As with specs or unit tests, you want to run the enforcement often and fail loudly. Your CI server is the perfect place for it. If your project does not have an `.rubocop_todo.yml` file, then all you need to do is to invoke `rubocop` on the build.

If you do have a `.rubocop_todo.yml` file, I recommend that you create a specific configuration for CI, like so:

```
# .rubocop_ci.yml
inherit_from:
  - .rubocop.yml
  - .rubocop_todo.yml
```

And configure CI to use it:

```
$ rubocop --config .rubocop_ci.yml
```

This will pick-up your settings from `.rubocop.yml` and then apply any exclusions in `.rubocop_todo.yml`. For local development, I have my editor run `rubocop` when I save any file, but pointing to the regular `.rubocop.yml` file. That way, I can see any offenses on any file I work on and are reminded to fix them as I go.

I am currently using [Atom][atom] with the [linter-rubocop][linter-rubocop] package.

## Sharing Rubocop Configuration Among Projects

If you are working in multiple code bases, you probably don't want to manually maintain separate configuration files for each project and have sync changes to your style config for each one. `rubocop` provides a few mechanisms to deal with this problem. My favorite is it's ability to inherit configuration from a file inside a gem. This allows us to create a gem that holds the configuration and use it from all our other projects. This not only removes the duplication, but you can also take advantage of gem versioning to control when new style guidelines are brought into each project. Of course, the downside of that is that you still need to remember to upgrade the gem version on each project using it. I see that as less of an issue, because I recon that most teams already have a process in place to update their projects dependencies on a regular basis.

A `.rubocop.yml` file with gem inheritance:

```
inherit_gem:
  your_team_style_gem_name: .rubocop.yml
```

`rubocop` itself changes often and new versions tend to bring in new cops that where not there before. Even if your config or your code hasn't changed, updating `rubocop` can cause new offenses to show up. That is undesirable, especially if running on CI. However, by managing `rubocop` config in a gem, you can also pin the specific version of `rubocop` in the gemspec.

## Conclusion / Parting Thoughts

The process of deciding on a style guide and enforcing it can be difficult. A team challenge, as opposed to a technical one. It can bring a lot of value to a team. It's about the journey. The destination can be pretty nice, too.


[ruby_style_guide]: https://github.com/bbatsov/ruby-style-guide
[rubocop]: https://github.com/bbatsov/rubocop
[rubocop_docs]: https://rubocop.readthedocs.io
[atom]: https://atom.io
[linter-rubocop]: https://atom.io/packages/linter-rubocop
