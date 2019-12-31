---
layout: post
title: "Spring Hopes Eternal"
date: 2019-08-16 11:43:38 -0700
comments: true
categories:
- rails
- git
---

I have a love-hate relationship with `spring`, Rails' [application pre-loader][spring]. One one hand, it speeds up the feedback loop when doing TDD. Faster running specs, promote running them more often, which promotes writing code in smaller increments, and so forth. On the other hand, it is dark magic: In its quest to be unobtrusive, it starts automatically, and barely reports it's being used at all. Occasionally it looses track of which code it needs to reload, causing much confusion to the user, as the code executing is different than the version saved on disk.

For a while, I disabled its use all together, by setting the `DISABLE_SPRING` environment variable. I found it tolerable while working on smaller rails apps, but not on the giant rails monolith I use everyday:

```ruby
# spec/example_spec.rb
require 'rails_helper'

RSpec.describe 'A spec' do
  it 'states the obvious' do
    expect(1).to eq(1)
  end
end
```

Let's time with and without `spring`:

```text
$ time bin/rspec spec/example_spec.rb
Running via Spring preloader in process 26118

Randomized with seed 15334
.

Finished in 0.05529 seconds (files took 3.86 seconds to load)
1 example, 0 failures

Randomized with seed 15334

bin/rspec spec/example_spec.rb  0.27s user 0.11s system 7% cpu 5.050 total

$ bin/spring stop
Spring stopped.

$ export DISABLE_SPRING=yes_please

$ time bin/rspec spec/example_spec.rb
Randomized with seed 42078
.

Finished in 0.09926 seconds (files took 9.99 seconds to load)
1 example, 0 failures

Randomized with seed 42078

bin/rspec spec/example_spec.rb  11.03s user 1.35s system 98% cpu 12.547 total
```

Running with `spring` takes 0.27 seconds. Running without takes 11.03. Can I have my cake and eat it too?

# Git Hooks

I don't have conclusive evidence, but I've noticed that code loading issues creep into spring when changing git branches. Git provides a mechanism to [hook into it's events][git-hooks] and run an arbitrary script. Putting it all together, I created git hooks that stop spring:

```bash
#!/usr/bin/env bash
# Copy this script to .git/hooks/post-checkout
# Make it executable (chmod +x ..git/hooks/post-checkout)

# The hook is given three parameters: the ref of the previous HEAD,
# the ref of the new HEAD (which may or may not have changed),
# and a flag indicating whether the checkout was a branch checkout
# (changing branches, flag=1) or a file checkout
# (retrieving a file from the index, flag=0).
if [[ "$3" == "1" ]] && [[ "$1" != "$2" ]]; then
  # Stop spring, if we have the binstub fot it

  spring_command="bin/spring"

  [[ -x "$spring_command" ]] || exit

  echo "Git Hook: Stopping spring"
  exec $spring_command stop
fi
```

I've been using the above hook for weeks. I haven't encountered a code loading issue yet.

[spring]: https://github.com/rails/spring
[git-hooks]: https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks
