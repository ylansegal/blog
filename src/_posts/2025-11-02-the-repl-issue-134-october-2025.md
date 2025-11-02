---
layout: post
title: "The REPL: Issue 134 - October 2025"
date: 2025-11-02 13:13:06 -0800
categories:
- machine_learning
- software
- ruby
excerpt_separator: <!-- more -->
---

### [Vibing a Non-Trivial Ghostty Feature](https://mitchellh.com/writing/non-trivial-vibing)

Mitchell Hashimoto's extensive post details his use of AI to code a Ghostty[^1] feature, mirroring my own experience with AI. It excels at prototyping and boilerplate, and is good at explaining existing code. However, it requires constant supervision; I frequently tweak and guide its output. Sometimes, it misses the mark entirely and gets stuck.

### [Abstraction, not syntax](https://ruudvanasseldonk.com/2025/abstraction-not-syntax)

> Alternative configuration formats solve superficial problems. Configuration languages solve the deeper problem: the need for abstraction.

Abstraction, while simplifying expression, comes at the the cost of *generating* the configuration file, as the article explains. However, the author omits that YAML supports references, offering a degree of abstraction:

```yml
# Define reusable base configurations
.defaults: &defaults
  region: "eu-west"

.lifecycle_policies:
  hourly: &hourly-policy
    delete_after_seconds: 345600  # 4 days
  daily: &daily-policy
    delete_after_seconds: 2592000  # 30 days
  monthly: &monthly-policy
    delete_after_seconds: 31536000  # 365 days

buckets:
  - <<: *defaults
    name: "alpha-hourly"
    lifecycle_policy: *hourly-policy
  - <<: *defaults
    name: "alpha-daily"
    lifecycle_policy: *daily-policy
  - <<: *defaults
    name: "alpha-monthly"
    lifecycle_policy: *monthly-policy
  - <<: *defaults
    name: "bravo-hourly"
    lifecycle_policy: *hourly-policy
  - <<: *defaults
    name: "bravo-daily"
    lifecycle_policy: *daily-policy
  - <<: *defaults
    name: "bravo-monthly"
    lifecycle_policy: *monthly-policy
```

While this is not a while loop, it does remove the repetition, and the need to check each of the values multiple times.

### [Locating Elements in Hash Arrays Using Pattern Matching in Ruby](https://allaboutcoding.ghinda.com/how-to-use-pattern-matching-to-locate-elements-in-a-hash-array)

Pattern matching in Ruby is still relatively new. I've only seen it used sparingly, but this use is concise. I'm still mulling over the syntax. Assigning to feels weird. A few years ago, when numbered parameters (e.g., `collection.each { _1.do_something }`) were introduced, I didn't care much for them. Now, I am on a team that uses them constantly and the syntax has grown on me. Perhaps pattern matching like this will take hold in time.

```ruby
system = {
  users: [
    { username: 'alice', role: 'admin', email: 'alice@example.com' },
    { username: 'bob', role: 'user', email: 'bob@example.com' },
    { username: 'charlie', role: 'moderator', email: 'charlie@example.com' }
  ]
}

system => {users: [*, { role: 'moderator', email: }, *]}
puts email # charlie@example.com
```

[^1]: [Ghostty](https://ghostty.org) is an excellent terminal emulator. After using iTerm 2 for years, I tried ghostty and haven't looked back.
