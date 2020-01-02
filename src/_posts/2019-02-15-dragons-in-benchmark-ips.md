---
layout: post
title: "Dragons in benchmark-ips"
date: 2019-02-15 12:55:52 -0800
comments: true
categories:
- ruby
---

My go-to tool for analyzing ruby performance is [benchmark-ips][1]. It's an enhancement to Ruby's own stdlib tool `Benchmark`. It's easy to use, and reports meaningful information by default.

Recently, while running a benchmark, I was getting very odd results. One of the alternatives reported thousand of times slower. That was not in line with my expectations. As a sanity test, I had both blocks run the same code:

```ruby
require 'benchmark/ips'

Benchmark.ips do |x|
  x.report("option A") do
    Object.new
  end

  x.report("option B") do |times|
    Object.new
  end

  x.compare!
end

# >> Warming up --------------------------------------
# >>             option A   213.307k i/100ms
# >>             option B   257.225k i/100ms
# >> Calculating -------------------------------------
# >>             option A      5.958M (± 6.5%) i/s -     29.650M in   5.001835s
# >>             option B    254.000B (± 9.7%) i/s -    709.200B in   3.014349s
# >>
# >> Comparison:
# >>             option B: 254000471514.5 i/s
# >>             option A:  5958499.2 i/s - 42628.26x  slower
# >>
```

It took a few minutes, before I spotted the difference: The second block is making `times` available to the block, while the first is not. After setting up both blocks in the same way:

```ruby
require 'benchmark/ips'

Benchmark.ips do |x|
  x.report("option A") do
    Object.new
  end

  x.report("option B") do
    Object.new
  end

  x.compare!
end

# >> Warming up --------------------------------------
# >>             option A   227.941k i/100ms
# >>             option B   229.945k i/100ms
# >> Calculating -------------------------------------
# >>             option A      6.299M (± 2.3%) i/s -     31.684M in   5.032681s
# >>             option B      6.279M (± 3.3%) i/s -     31.502M in   5.023744s
# >>
# >> Comparison:
# >>             option A:  6299217.3 i/s
# >>             option B:  6278600.3 i/s - same-ish: difference falls within error
# >>
```

That is more like it: Identical code performs the same.

[1]: https://github.com/evanphx/benchmark-ips
