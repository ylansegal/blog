---
layout: post
title: "Stop Using next in Ruby Loops"
date: 2026-03-20 15:18:30 -0700
categories:
- ruby
excerpt_separator: <!-- more -->
---

LLM-generated Ruby code tends to reach for `next` inside `.each` loops. It works, but it's not idiomatic. When you find yourself using `next`, there's almost always a more expressive alternative using Enumerable methods.

## A Simple Example

Consider this loop that collects names of active users:

```ruby
names = []
users.each do |user|
  next if user.inactive?

  names << user.name
end
```

The `next if` is doing filtering, but it doesn't *say* filtering. It says "skip this one," which forces the reader to mentally invert the condition to understand what's being *kept*. Compare:

```ruby
names = users.reject(&:inactive?).map(&:name)
```

The intent is explicit: reject inactive users, then map to names. Each method communicates exactly one operation.

## Discrete Steps

Enumerable methods let you express collection processing as discrete, named steps: `select`, `reject`, `map`, `filter_map`. Each step communicates intent. When you use `next` inside `.each`, you combine filtering and transformation into one opaque block. The reader has to mentally simulate the loop to understand what it does.

Named methods are also composable. You can add, remove, or reorder steps without restructuring the entire loop. A chain of Enumerable methods reads as a description of *what* the code does, not *how* it iterates.

## A More Complex Example

Here's a loop that processes orders with multiple conditions:

```ruby
summaries = []
orders.each do |order|
  next if order.cancelled?
  next if order.total < 100
  next unless order.region == "US"

  summaries << {
    id: order.id,
    total: order.total,
    customer: order.customer_name
  }
end
```

Three `next` statements, each encoding a different filter. You have to read all of them to understand which orders survive. Compare:

```ruby
summaries = orders
  .reject(&:cancelled?)
  .select { |o| o.total >= 100 }
  .select { |o| o.region == "US" }
  .map { |o| { id: o.id, total: o.total, customer: o.customer_name } }
```

Each step is readable in isolation. The pipeline reads as a description: reject cancelled orders, keep those above $100 in the US region, then transform to summaries.

## One Operation Per Step

Enumerable has methods like `filter_map` that combine more than one operation. They can be useful, but at the cost of obscuring intent. Consider:

```ruby
results = items
  .select(&:valid?)
  .filter_map { |item| item.compute_value }
```

`filter_map` maps and removes `nil` results in one pass. But the reader has to know that to understand what's happening. Compare:

```ruby
results = items
  .select(&:valid?)
  .map { |item| item.compute_value }
  .compact
```

Each step does one thing: select valid items, transform them, remove nils. The tradeoff is worth considering -- `filter_map` is more concise, but `.map { ... }.compact` makes every operation visible.

## What About Performance?

The obvious objection: chaining creates intermediate arrays, while the `.each` loop iterates only once. In practice, this rarely matters. But when it does, that's what `lazy` is for:

```ruby
summaries = orders
  .lazy
  .reject(&:cancelled?)
  .select { |o| o.total >= 100 }
  .select { |o| o.region == "US" }
  .map { |o| { id: o.id, total: o.total, customer: o.customer_name } }
  .to_a
```

Same expressive chain, single-pass iteration. You get clarity *and* performance.

## Conclusion

When you see `next` in a loop, treat it as a signal. There's probably an Enumerable method that says what you mean more clearly.
