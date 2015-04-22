---
layout: post
title: "Recursion and Pattern Matching in Elixir"
date: 2015-04-22 09:00:33 -0700
comments: true
categories:
- elixir
---

In order to teach myself [Elixir][1], I have been working my way through [Exercism.io][2], which is a set of practice coding exercises with mentorship from the community. All exercises have the tests written for you and it's up to the user to write a passing implementation.

Being new to Elixir and functional programming, the exercises are a great way for me to learn about syntax, idiomatic code and functional programming patterns. One of exercises consists of re-implementing common list operations, like `count`, `map` and `reduce`.

# Implementing Count With Recursion

The test that the implementation must pass looks like this:

``` elixir
defmodule ListOpsTest do
  alias ListOps, as: L

  use ExUnit.Case, async: true

  test "count of empty list" do
    assert L.count([]) == 0
  end

  test "count of normal list" do
    assert L.count([1,3,5,7]) == 4
  end

  test "count of huge list" do
    assert L.count(Enum.to_list(1..1_000_000)) == 1_000_000
  end
end
```

My first implementation, looked like this:

``` elixir
defmodule ListOps do
  def count(list) do
    count(0, list)
  end

  def count(acc, []) do
    acc
  end

  def count(acc, [_|tail]) do
    count(acc + 1, tail)
  end
end
```

First thing of note: `count/2`[^1] is defined twice. This is part of the language provided functionality. In Java, method overloading required a different number of parameters which is how the dispatching picked the correct method at runtime. In Ruby, there can't exist to method definitions in the same scope. In Elixir, the correct function is called at run-time depending on which pattern is matched.

On our first test, when `L.count([])` is called, the `count/1` function matches, because it only has one parameters. That function calls `count(0, [])`. This will match the first `count/2` definition, because it is being passed with an empty list. (Any `acc` will match). That in turn returns `acc`, which is 0, making the test pass.

For the second test, `count/1` is matched, which ends up calling `count(0, [1,3,5,7])`. That call, matches the second `count/2` definition, because it matches a list that is not empty[^2]. That function call will call recursively, adding 1 to the accumulator each call, until the list is empty and the accumulator is returned.

The calls will look like:

``` elixir
count([1,3,5,7])
count(0, [1,3,5,7])
count(1, [3,5,7])
count(2, [5,7])
count(3, [5])
count(4, []) # Returns 4
```

Note that recursion and pattern matching have taken the place of conditionals or explicit loops in the code, as you would have in non-functional programming languages.

# Implementing Count With Reduce

The same exercise asks to implement a `reduce` function that will run a generic function on each element of a list and pass the resulting accumulator. My implementation looks like this:

``` elixir
defmodule ListOps do
  def reduce([], acc, _fun) do
    acc
  end

  def reduce([head|tail], acc, fun) do
    reduce(tail, fun.(head, acc), fun)
  end
end
```

The same trick as before is used here, where matching on an empty list returns the accumulator. When a list has at list one member, the function is called for that member and `reduce/3` is called with the tail of the list recursively.

With `reduce/3` in place, the `count/1` implementation becomes much simpler:

``` elixir
defmodule ListOps do
  def count(list) do
    reduce(list, 0, fn(_, acc) -> acc + 1 end)
  end
end
```

# Conclusion

The exercise has some other operations as well: `map`, `reverse`, `filter`, `append` and `concat`. I learned a lot working on the solutions and started to get a feel for functional programming. If you are learning a new language, I would recommend trying Exercism.io. It currently supports 23 languages!

[^1]: In Elixir, when referring to functions, it is customary to add `/` and the arity to the name. `foo/2` refers to the function `foo` defined with 2 parameters.
[^2]: Elixir includes matching a list to it's head and tail with the [head|tail] syntax. The `_` signals that the parameter will not be used.

[1]: http://elixir-lang.org/
[2]: http://exercism.io/
