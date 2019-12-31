---
layout: post
title: "Structs With Keyword Arguments in Ruby 2.5"
date: 2018-01-05 18:11:41 -0800
comments: true
categories:
- ruby
---

Ruby 2.5 was released a few days ago. Among the new [features][1], `Struct`s gained the ability to be instantiated with using keyword arguments.

Ruby has traditionally had the ability to create a classes that bundle data attributes together, provide accessors for those attributes and other methods like converting into a hash:

```ruby
Point = Struct.new(:x, :y)
p = Point.new(2, 3) # => #<struct Point x=2, y=3>
p.x # => 2
p.y # => 3
p.to_h # => {:x=>2, :y=>3}
```

Notice, that the newly created class is initialized with positional arguments. Often when using Ruby -- especially when using Rails, data is passed around in hashes. For example, let's assume that we are instantiating an instance of a `Point` inside a controller action using Rails. The instantiation would look something similar to:

``` ruby
point = Point.new(params[:x], params[:y])
```

As the number of positional arguments grow, this can become tedious. Ruby 2.5 ships with a new feature that allows creating `Struct`s that accept keyword arguments, much like `ActiveRecord` models do, as described in this [feature request][2].

```ruby
Point = Struct.new(:x, :y, keyword_init: true)
Point.new(x: 1, y: 2) # => #<struct Point x=1, y=2>
Point.new(y: 2, x: 1) # => #<struct Point x=1, y=2>
```

There are a few things to note. When using keyword arguments, if a value is missing, it will be set to `nil`. Additionally, if extra arguments are supplied, an `ArgumentError` will be raised:

``` ruby
Point = Struct.new(:x, :y, keyword_init: true)
Point.new(y: 2) # => #<struct Point x=nil, y=2>
Point.new(x: 1, y: 2, z: 3) # => ArgumentError: unknown keywords: z
```

---

Stuck in an older ruby? You can easily build similar support on your own, which I often do in projects I work on:

``` ruby
module StructKeywordInitialization
  def initialize(args)
    members.each do |field|
      self.public_send("#{field}=", args[field])
    end
  end
end

Point = Struct.new(:x, :y) do
  include StructKeywordInitialization
end

Point.new(x: 1, y: 2)       # => #<struct Point x=1, y=2>
Point.new(y: 2)             # => #<struct Point x=nil, y=2>
Point.new(x: 1, y: 2, z: 3) # => #<struct Point x=1, y=2>
```

We've created a new module that takes advantage of the `#members` method in `Struct` to define a dynamic initializer. Note that in this version, extra arguments *will not* raise an `ArgumentError`. Depending on your application, this might be a better fit or not. It's left to the reader to make a version that does raise an error with extra arguments.

[1]: https://www.ruby-lang.org/en/news/2017/12/25/ruby-2-5-0-released/
[2]: https://bugs.ruby-lang.org/issues/11925
