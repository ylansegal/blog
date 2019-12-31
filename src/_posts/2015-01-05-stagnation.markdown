---
layout: post
title: "Stagnation"
date: 2015-01-05 20:56:39 -0800
comments: true
categories:
- ruby
---

Dependency management in Ruby, is almost universally done with Bundler. It provides an easy way to declare other Ruby dependencies in your application and install them on demand. It manages the explicit dependencies you tell it about in your `Gemfile` and also resolves the transitive dependencies, those that you do not specify directly, but are declared by the dependencies themselves.

Bundler generates a `Gemfile.lock` that locks those dependencies to specific versions to ensure that your application is tested and deployed to production with a known environment. The procedure solves a number of problems, one of them being insulating your application from change.

That code that you write depends on a stack of other software to operate correctly, to fulfill the function it was designed for. Bundler recognizes that in the future, new versions of the components of the stack will be release and introduce breaking changes. They will no longer work with your application in the same manner they do now.

<!-- more -->

Bundler solves this problem for Ruby libraries (and their native extensions) very well. Your software, however, depends on other components: Some of them under your control, like the operating system it runs on or the data stores you choose to use. Some of them are not under your control at all, like external services or even the client / browser that consumes your application[^1].

There are a number of mechanisms that you can use to manage the change in the components you do have control over. Tools like Chef and Puppet provide a way to provision servers repeatedly to a known version and this is taken to the next level by newcomers like Docker.

These tools, effectively allow you to stop change from adversely affecting your application at a cost: Preventing change from *positively* affecting your application.

Positive change can come from simple big fixes and performance improvements or, more seriously, from security fixes to vulnerabilities that threaten your application and presumably the value they bring. I can't imagine a web developer that during 2014 didn't witness or participated in several panic-filled updates to production servers due to security vulnerabilities like Heartbleed or POODLE[^2].

Those same mechanism that allow you to manage change to reduce risk, also make it easy to forget about change altogether . I have observed this phenomenon more commonly in mature apps that have reached a point in their development where new features are not added or needed regularly, but are still live and continuously providing value to its users. With no active development, inertia will let those apps stagnate in time: The libraries stay locked at old versions; with time become unsupported because the maintainers are now focused on the latest and greatest.


> stagnate |ˈstagˌnāt|
verb [ no obj. ]
(of water or air) cease to flow or move; become stagnant.
cease developing; become inactive or dull

The stagnation comes slowly but surely, until your hand is forced. One of the libraries, or the language itself has a security vulnerability that needs to be addressed but your app cannot be upgraded easily. Its dependency tree is locked in the past and you are left with a mad scramble to upgrade individual libraries that conflict with each other. You end up forking libraries to apply patches and your maintenance burden is even greater than before. This is the danger of stagnation: Not being able to change when you really need to.

The solution then, is to manage change effectively, making it part of your process. Constantly making incremental changes to your stack is a far easier proposition and in the end keeps your app's most-needed ability to constantly change.


[^1]: Browsers continually change. In the future they might render your HTML or run your JavaScript differently than they do know. They might also be running in devices you haven't prepared for. The apps I wrote in 2000 has absolutely no preparations for small-yet-very-capable screens, like today's smartphones. They did take into account slow internet connections, though.

[^2]: If you are one of those developers, I strongly advise to ask yourself why you were not a part of that panic. The mentioned vulnerabilities were as bad as they come. Your organization should have addressed them ASAP.
