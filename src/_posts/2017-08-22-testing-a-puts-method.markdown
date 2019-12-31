---
layout: post
title: "Testing a puts method"
date: 2017-08-22 09:27:13 -0700
comments: true
categories:
- ruby
- design
---

When I code long-running tasks, I often want to see some sort of progress report in my terminal to let me know that my code is still running. Let's take a simple example:

```ruby
class ThumbnailCreator
  def process
    images.each_with_index do |image, index|
      # ...
      puts "Processed #{index + 1} images" if index % 10 == 0
    end
  end

  private

  def images
    # ... somehow find eligible images for processing
  end
end
```

The above code will print a new line to the console every 10th image processed. While this approach works, it is also hard to test and causes undesired output when running my tests. Can we do better? Where does the `puts` method comes from:

```
pry(main)> show-doc ThumbnailCreator#puts

From: io.c (C Method):
Owner: Kernel
Visibility: private
Signature: puts(*arg1)
Number of lines: 3

Equivalent to

    $stdout.puts(obj, ...)
```

[`pry`][^1] makes it easy to trace the source of that method the `Kernel` module. Furthermore, it lets us know that `Kernel#puts` is equivalent to calling `$stdout.puts`. `$stdout` is a global ruby constant, which holds the current standard output. We can make that explicit in our code:

```ruby
class ThumbnailCreator
  def process
    images.each_with_index do |image, index|
      # ...
      $stdout.puts "Processed #{index} images" if index % 10 == 0
    end
  end
end
```

Adding an explicit receiver for the `puts` makes the code a bit longer and more verbose -- usually things that rubyists shun. It also makes it clear that our class is collaborating with `$stdout`, a different object. Once we realize that, it follows that we can also make this collaboration configurable through dependency injection.


```ruby
class ThumbnailCreator
  def initialize(out = $stdout)
    @out = out
  end

  def process
    images.each_with_index do |image, index|
      # ...
      @out.puts "Processed #{index} images" if index % 10 == 0
    end
  end
end
```

All existing code that use our class continue to work as before: The default value for `out` will ensure that by default, we continue printing to `$stdout`. However, in our tests, we can now inject a different collaborator. What can we use?

So far, we've used only one method on `out`. Ruby will happily let us inject any object that we want, as long as it implements `puts` in a compatible manner (in terms of arity). However, there is a risk that our tests can become *too* coupled to our implementation by only passing an object that implements the narrowest of interfaces. Ruby's stdlib includes a class that we can use: `StringIO`

```
$ ri StringIO

= StringIO < Data

------------------------------------------------------------------------------
= Includes:
(from ruby core)
  Enumerable
  IO::generic_readable
  IO::generic_writable

(from ruby core)
------------------------------------------------------------------------------
Pseudo I/O on String object.

Commonly used to simulate `$stdio` or `$stderr`

=== Examples

  require 'stringio'

  io = StringIO.new
  io.puts "Hello World"
  io.string #=> "Hello World\n"
------------------------------------------------------------------------------
```

Our tests can now use and verify the collaborator:

```ruby
require "rspec"

describe ThumbnailCreator do
  subject { described_class.new(out) }
  let(:out) { StringIO.new }

  it "shows progress while processing images" do
    subject.process

    expect(out.string).to match(/Processed/)
  end
end
```

## Conclusion

Often classes collaborate implicitly with other objects. Making the collaboration explicit allows us to use dependency injection as a way to configure behavior, resulting in a more modular design. Our initial motivation to test our code resulted in a better design, at little cost.

[^1]: Pry is an IRB alternative and runtime developer console http://pryrepl.org/
