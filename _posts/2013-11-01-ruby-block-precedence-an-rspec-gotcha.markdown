---
layout: post
title: "Ruby Block Precedence: An Rspec Gotcha"
date: 2013-11-01 09:01
comments: true
categories:
- rspec
- ruby
- tdd
- most_popular
---

Recently I came across a spec that didn't seem to be executing the assertion block passed in to the raise_error expectation. Leaving the bare essentials for the example:

``` ruby
require 'rspec'

describe 'Block Precedence' do
  it 'expecting this spec to fail' do
    expect { raise 'Opps'}.to raise_error do |error|
      1.should == 2
    end
  end
end

```

We raise an exception, assert that it was raised and the try to assert something about the exception. In this example, `1.should == 2` should clearly fail. However, when we run this:

```
$ rspec rspec_example.rb
.

Finished in 0.001 secon
```

It would seem that the block is never being executed.

<!-- more -->

## Curly Blocks To The Rescue

After fiddling around for a while and talking to some co-workers, it came to light that curly blocks behave slightly different:

``` ruby
require 'rspec'

describe 'Block Precedence' do
  context 'with do block' do
    it 'expecting this spec to fail' do
      expect { raise 'Opps'}.to raise_error do |error|
        1.should == 2
      end
    end
  end

  context 'with curly block' do
    it 'expecting this spec to fail' do
      expect { raise 'Opps'}.to raise_error { |error|
        error.should_not be_a(Exception)
      }
    end
  end
end
```

The curly blocks, do seem to execute:

```
$ rspec rspec_example.rb
.F

Failures:

  1) Block Precedence with curly block expecting this spec to fail
     Failure/Error: expect { raise 'Opps'}.to raise_error { |error|
       expected #<RuntimeError: Opps> not to be a kind of Exception
     # ./rspec_example.rb:14:in `block (3 levels) in <top (required)>'

Finished in 0.0014 seconds
2 examples, 1 failure

Failed examples:

rspec ./rspec_example.rb:13 # Block Precedence with curly block expecting this spec to fail
```

Most of the time in ruby, one can treat `do...end` blocks and `{}` blocks the same, but there are some subtleties to them. Refere to this [stackoverflow answer][1] for more information and examples.

In short, you can use the `do..end` by adding parenthesis to establish precedence, or use the curly braces:

``` ruby
require 'rspec'

describe 'Block Precedence' do
  context 'with do block' do
    it 'expecting this spec to fail' do
      expect { raise 'Opps'}.to( raise_error do |error|
        1.should == 2
      end)
    end
  end

  context 'with curly block' do
    it 'expecting this spec to fail' do
      expect { raise 'Opps'}.to raise_error { |error|
        error.should_not be_a(Exception)
      }
    end
  end
end
```

Both this examples will fail, as expected. I personally do not like the parenthesis after the end keyword, so I am going to prefer curly block in the future.

## Conclusion: Word About TDD

The danger exposed in the examples above is that we are getting false-green specs: They pass the specs, but they should be breaking. It seems completely unrelated to TDD, but it is not.

I only came to learn about the block precedence because in the code I was working on, I wrote my specs first. I ran the spec, expecting to see a a failure because the code had not been implemented and got a green instead. This is the standard Agile red-green-refactor cycle.

Had I written my code first and then the test, it would have been entirely possible that I would have gotten green and continued on, without realizing it was a false green.

[1]: http://stackoverflow.com/questions/5587264/do-end-vs-curly-braces-for-blocks-in-ruby
