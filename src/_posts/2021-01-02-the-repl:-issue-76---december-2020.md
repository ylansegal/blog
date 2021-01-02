---
layout: post
title: "The REPL: Issue 76 - December 2020"
date: 2021-01-02 14:47:05 -0800
categories:
- the repl
excerpt_separator: <!-- more -->
---

### [Command Line Interface Guidelines][1]

> An open-source guide to help you write better command-line programs, taking traditional UNIX principles and updating them for the modern day.

This is a great idea. CLI programs might not have a graphical interface, but there is still user experience to consider. This guides provides a starting point, with rationale behind the philosophy of the guide. In particular, I was pleasantly surprised by the author's humbleness:

> It’s ironic that this document implores you to follow existing patterns, right alongside advice that contradicts decades of command-line tradition. We’re just as guilty of breaking the rules as anyone.

> The time might come when you, too, have to break the rules. Do so with intention and clarity of purpose.

### [What Shape are You?][2]

The article has an interesting metaphor: In collaboration teams, the shape of your work is important. The work that someone does can leave gaps that can be left undone that no one else is really capable of doing. For example, if you don't write tests or comment your code, it is really hard for the rest of the team to compensate and do that for you. They don't have enough context.

Another interesting concept is that some work can be either additive or subtractive. Additive would be something like making widgets. The more you do, the better. Software projects are subtractive: We keep working until we have done all the work that is left. In this sense, someone can do a lot of work in a team -- even more than anyone else -- but still leave gaps that prevent the project from succeeding.

I don't think the subtractive analogy is quite true: Software projects are not really a static set of work. It can grow and shrink, while still being successful. That is the reasoning behind MVPs, or prioritizing work to deliver value. In fact, the software projects that I work on, are not really ever done. The software continues to evolve. The author comes from a gaming background, which might explain a different mentality. In any case, software does have a subtractive quality to it: Some of the work needs to be done by someone, and a team member that leaves gaps requires others to take that up.

### [Climbing Steep hills, or adopting Ruby 3 types with RBS][3]

Ruby 3.0 was just released. It includes RBS, a language to describe type signatures for Ruby programs. In this post Vladimir Dementyev explains in hands-on detail how to use RBS to add types to Ruby programs. The type system is designed to be gradual. It makes it easier to start adopting it. Of course, the more type information is provided, the more effective the type-checker is.


[1]: https://clig.dev/
[2]: https://tynan.com/shapes
[3]: https://evilmartians.com/chronicles/climbing-steep-hills-or-adopting-ruby-types
