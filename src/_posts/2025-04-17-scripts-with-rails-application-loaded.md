---
layout: post
title: "Scripts With Rails Application Loaded"
date: 2025-04-17 16:42:24 -0700
categories:
- rails
excerpt_separator: <!-- more -->
---

I often need to write some scripts for my Rails applications. These are sometimes intended to be run in development or production environments, and require that the Rails application is loaded. The most common way I've seen of doing this is with a `rake` task:

```ruby
namespace :import do
  desc "Import people. Requires a file name as argument"
  task :people, %i[file_path] => :environment do |_t, args|
    puts "Importing people from #{args[:file_path]}"
    People::Import.new(args[:file_path]).perform
    puts "Done"
  end
end
```

`rake` tasks have their benefits, but the argument handling is not like most other unix programs. They are passed as an array at the end of the task name:

```
bash-5.2$ rake import:people[people.csv]
Importing people from people.csv
Done
```

Even more troubling, is that if you use `zsh` (and I am!), the `[` and `]` need to be escaped, or the whole argument to `rake` quoted:

```
$ rake import:people\[people.csv\]

# OR

rake "import:people[people.csv]"
```

## Rails runner

You can use `rails runner` to run **any** ruby file in the context of the rails application:

```ruby
# import.rb

puts "Importing people from #{ARGV.first}"
People::Import.new(ARGV.first).perform
puts "Done"
```

And run it by passing your file as the first argument:

```
$ rails runner import.rb people.csv
```

But you can also use `rails runner` as a shebang line.

```ruby
#!/usr/bin/env rails runner
# bin/import
puts "Importing people from #{ARGV.first}"
People::Import.new(ARGV.first).perform
puts "Done"
```

And now you can invoke that directly:

```
$ chmod +x bin/import

$ bin/import people.csv
```

The shebang line allows your script to be directly executable. Now, you can make it more ergonomic, and build up a unix-like command:

```ruby
#!/usr/bin/env rails runner
# bin/import

options = {}
OptionParser.new do |parser|
  parser.banner = "Usage: rails runner example.rb [options]"

  parser.on("-f", "--file FILE", "Import from FILE") do |file|
    options[:file] = file
  end

  parser.on("-h", "--help", "Prints this help") do
    puts parser
    exit
  end
end.tap(&:parse!)

puts "Importing people from #{options[:file]}"
# ...
```

```
$ bin/import --file people.csv
# ...

$ bin/import -h
Usage: rails runner example.rb [options]
    -f, --file FILE                  Import from FILE
    -h, --help                       Prints this help
```

## Conclusion

Using `rails runner` as a shebang allows full access to the Rails environment in your script, without having to sacrifice command-line ergonomics.
