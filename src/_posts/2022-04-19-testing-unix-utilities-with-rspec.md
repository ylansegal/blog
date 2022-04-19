---
layout: post
title: "Testing Unix Utilities With RSpec"
date: 2022-04-19 15:08:14 -0700
categories:
- ruby
- rspec
- unix
- tdd
excerpt_separator: <!-- more -->
# Post took 1:30 hours to write
---

I maintain a series of small unix scripts to make my daily usage more effective. I approach the development of these utilities like I do my other software: Use Outside-In Test-Driven Development. I use [rspec](https://rspec.info/) to write my tests, even if the code itself is written in `bash`, `zsh`, or `ruby`. Let's see a few examples.

## Testing Output

Some of my utilities are similar to pure functions: They always return the same output given for the same input, and they don't have side-effects (i.e. they don't change anything else in the system).

One of my most often used utility is `jira_ticket_number`. Given a string, it extracts the Jira ticket number from it. I typically don't call it directly, but use it in other scripts. In my typical workflow, I'll create a branch for a ticket I am working in, and include the ticket number in the name (e.g. `ys/CF-8176_rework_request_sweeper`). This is useful in a few ways. I use it in another utility `jira`, to construct and open a URL to the ticket. This saves me several clicks. I also use it to prepend new commit messages with the ticket number automatically when using `git`, via a custom `prepare-commit-msg` hook.

The specs for `jira_ticket_number`:

<!-- more -->

```ruby
require "spec_helper"

RSpec.describe "jira_ticket_number" do
  jira_truth_table = {
    "CF-7847/tc/woc_line_item_fk_validation" => "CF-7847",
    "PSI-2534" => "PSI-2534",
    "ys/CF-8176_rework_request_sweeper" => "CF-8176",
    "ys/CF-7996_upgrade_ruby_2.6" => "CF-7996"
  }.freeze

  jira_truth_table.each do |input, expected_output|
    it "it extracts #{expected_output} from #{input}" do
      output = `jira_ticket_number #{input}`
      expect(output).to eq("#{expected_output}\n")
    end
  end
end
```

We first define a "truth table": A data structure that holds several inputs and the expected output for each. For each one, we define a new expectation. It leverages ruby's ability to execute commands in a sub-shell and capture the output with <code>Kernel.``</code>. We can then compare it. Simple, yet effective.

## More Elaborate Setup

Another utility that I use regularly is `search`. I use it to find files that contain *all* of the patterns passed as arguments, optionally restricting the search to a given path. For example, say I want to find all controllers that inherit from `ApplicationController` and define an `index` action, I could run:

```bash
$ search '< ApplicationController' 'def index' --path app/controllers
```

Under the hood, it uses [ripgrep](https://github.com/BurntSushi/ripgrep), but that is incidental. My specs allow me to define the behavior, without worrying about the exact implementation. `search` is dependent on the input passed to it, but also on the files present in the file system. That means that our specs need to setup the expected state.

My first instinct was to create a temporary directory, create the files, and then run the specs. While that is a valid approach -- and we will get to another example like that later), I had a small epiphany. I could use the spec file itself as a match, if searching for unique content:

```ruby
require "spec_helper"
require "securerandom"

RSpec.describe "search" do
  let(:expr1) { "58115c4c9d7beac98196665ed3c84063" }
  let(:expr2) { "7f40073ed170b611caffebcbe2370884" }
  let(:expr3) { "c5b3b8bb490f02f7b3eaaeed58d77cf0" }
  # ...
end
```

What is more unique than UUIDs? The three strings (generated with `SecureRandom.hex`) above have a minuscule chance of being repeated elsewhere: especially if we limit the search to the directory that holds the spec file itself:

```ruby
it "finds containing multiple expressions without directory" do
  Dir.chdir File.dirname(__FILE__) do
    output = `search #{expr1} #{expr2} #{expr3}`
    expect(output).to eq("#{File.basename(__FILE__)}\n")
  end
end
```

In ruby `__FILE__` is a variable with the path to the file being executed (the spec file itself). `File.dirname` return the directory portion only. The `Dir.chdir` changes the execution of the ruby process to the directory holding the spec file, to limit the search.

The actual spec is similar to what we have before, using back-ticks to execute a sub-shell command. Lastly, since during execution we are in the same directory as the spec, we expect the output to only include the relative filename. `File.basename` strips away the rest of the path.

## Beyond back-ticks

For more complex utilities, using back-ticks is not flexible enough. Ruby has many other ways to [launch a sub-process](https://stackoverflow.com/a/31572431). In another of my utilities, I needed more flexibility to control `stdin` and `stdout`. The utility is called `io`, and it return both the input passed to it, and the commented-out results of the evaluation.

```ruby
require "spec_helper"
require "open3"

RSpec.describe "io" do
  it "filters out comments, executes code and puts result in comments" do
    input = <<~INPUT
      echo 'hello'
      # goodbye
    INPUT

    output = Open3.popen2(%(io sh)) do |stdin, stdout, _wait_thr|
      stdin.puts(input)
      stdin.close
      stdout.read
    end

    expect(output).to eq <<~OUTPUT
      echo 'hello'
      # hello
    OUTPUT
  end
end
```

Don't worry too much about what `io sh` is supposed to do. It's a utility I use for [fast feedback loops]({% post_url 2019-07-14-fast-feedback-loops %})  The important part is that with `Open3` we get more level of control of `stdin` and `stdout`.

## Tempdir

In other circumstances, we will need more control of what files exist in  a directory. Here is what another spec uses:

```ruby
require "spec_helper"
require "tmpdir"

RSpec.describe "zk_index_tags" do
  let(:zk_home) { Dir.mktmpdir }

  before do
    Dir.mkdir(File.join(zk_home, "Clips"))
    Dir.mkdir(File.join(zk_home, "Tags"))

    File.write File.join(zk_home, "Clips", "01-Note.md"), <<~MARKDOWN
      [[Tags/red]]
      [[Tags/blue]]

      Some other contents that should not be parsed
      # Some titles
      [A link](http:///not.parsed.come)
    MARKDOWN

    # ...

    File.write File.join(zk_home, "Tags.md"), <<~MARKDOWN
      [[Tags/yellow]]
    MARKDOWN
  end
end
```

`Dir.mktmpdir` will create a temporary directory, that the OS will take care of cleaning up for us. It also will be empty, allowing our `before` block to create and subdirectories and files we need to test out program.

## Conclusion

RSpec is an excellent testing framework. Ruby has a robust built-in capacity for executing commands in sub-shells and working with files and directories. In combination, they allows us to write concise and expressive tests for unix utilities, even if those utilities are not written in ruby.
