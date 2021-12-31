---
layout: post
title: "Celluloid, Nice to Meet You"
date: 2015-08-07 15:23:24 -0700
comments: true
categories:
- ruby
---

In my projects, I regularly encounter the need for a long-running process that runs in the background. In ruby, it's easy to reach for `Thread`:

``` ruby
Thread.new do
  loop do
    puts "Working..."
    work # Some actual work here...
  end
end
```

Although simple, it lacks fault tolerance: Any exception raised from `work` will terminate the loop and the thread. Often, the way to harden against this failure looks something like this:

``` ruby
Thread.new do
  begin
    loop do
      puts "Working..."
      work # Some actual work here...
    end
  rescue
    retry
  end
end
```

Rescuing from any exception and `retry`ing indefinitely. It's effective, but not very elegant. Earlier this week, I researched for a better pattern and found the [Celluloid][1] gem. In their words:

> [Celluloid is an] Actor-based concurrent object framework for Ruby

> Painless multithreaded programming for Ruby

Actors? You mean, like in Erlang? It turns out, I have been reading a lot about [Elixir][2] lately, so I was eager to try it.

## A Simple Example

Celluloid's basic unit is called an Actor. A simple ruby class that includes the `Celluloid` module is now transformed into a multi-threaded object.

``` ruby
class Worker
  include Celluloid
  include Celluloid::Logger # So that we can use the familiar #info, #error, etc.

  def initialize
    @uid = SecureRandom.uuid
    async.work
  end

  def work
    loop do
      info "[#{@uid}] - Working..."
      fail "BOOM" if rand(10) < 3 # Simulate random failures
      sleep 1 # Simulating work
    end
  end
end
```
There a couple of interesting things in the code above. The initializer actually starts doing some work, asynchronously. The `#async` method is provided by `Celluloid`. Our main loop is in the work method, but we booby-trapped it to raise an exception at random times. Notice that neither the loop or the `work` method rescue any exceptions. Any exception raised will stop work.

Next, comes the interesting part:

``` ruby
class Group < Celluloid::SupervisionGroup
  supervise Worker, as: :worker
end
```

A supervision group, like `Group` is responsible for instantiating one or more actors, groups or pools of actors and supervising them: That is, if they "crash" or otherwise die, the supervisor will ensure that a new actor is re-intantiated in it's place. It will instantiate, but not call any method on the actor, which is why our initialize method calls `async.work`: To ensure that a crashed actor is replaced with another _running_ actor.

And to finally run it:

``` ruby
supervisor = Group.run!
sleep(10)
supervisor.actors.each(&:terminate)
```

Calliing `run!` starts the supervisor in the background. `run` would started in the foreground and block the rest of the thread. The sleep is required to prevent ruby's main thread from exiting. At the end of our test period, we gracefuly terminate our actors (one, actually).

So, what does this look like? As expected, `Worker#work` is prone to raising un-rescued exceptions, but we can see our supervisors starts a new `Worker` and fault-tolerance is achieved:

``` text
# Logfile created on 2015-08-05 17:39:04 -0700 by logger.rb/47272
I, [2015-08-05T17:39:04.594399 #49511]  INFO -- : [2b66f5f3-f36a-4465-8454-abbdd97d1c0d] - Working...
I, [2015-08-05T17:39:05.595124 #49511]  INFO -- : [2b66f5f3-f36a-4465-8454-abbdd97d1c0d] - Working...
E, [2015-08-05T17:39:05.595472 #49511] ERROR -- : Actor crashed!
RuntimeError: BOOM
    simple_poc.rb:18:in `block in work'
I, [2015-08-05T17:39:05.596377 #49511]  INFO -- : [05bfa2ea-78ab-41ce-bd26-ed82d46fbea9] - Working...
E, [2015-08-05T17:39:05.596564 #49511] ERROR -- : Actor crashed!
RuntimeError: BOOM
    simple_poc.rb:18:in `block in work'
I, [2015-08-05T17:39:05.597251 #49511]  INFO -- : [ad8a5361-fa49-4464-b059-405c86cfe4cf] - Working...
I, [2015-08-05T17:39:06.598375 #49511]  INFO -- : [ad8a5361-fa49-4464-b059-405c86cfe4cf] - Working...
I, [2015-08-05T17:39:07.601223 #49511]  INFO -- : [ad8a5361-fa49-4464-b059-405c86cfe4cf] - Working...
E, [2015-08-05T17:39:07.601420 #49511] ERROR -- : Actor crashed!
RuntimeError: BOOM
    simple_poc.rb:18:in `block in work'
I, [2015-08-05T17:39:07.602620 #49511]  INFO -- : [04b5959a-2156-4c39-8d8f-6660d561cc6d] - Working...
I, [2015-08-05T17:39:08.607258 #49511]  INFO -- : [04b5959a-2156-4c39-8d8f-6660d561cc6d] - Working...
I, [2015-08-05T17:39:09.607827 #49511]  INFO -- : [04b5959a-2156-4c39-8d8f-6660d561cc6d] - Working...
E, [2015-08-05T17:39:09.608015 #49511] ERROR -- : Actor crashed!
RuntimeError: BOOM
    simple_poc.rb:18:in `block in work'
I, [2015-08-05T17:39:09.608841 #49511]  INFO -- : [eca10599-6648-4625-8f09-99be2add3b16] - Working...
I, [2015-08-05T17:39:10.614044 #49511]  INFO -- : [eca10599-6648-4625-8f09-99be2add3b16] - Working...
I, [2015-08-05T17:39:11.615554 #49511]  INFO -- : [eca10599-6648-4625-8f09-99be2add3b16] - Working...
I, [2015-08-05T17:39:12.615923 #49511]  INFO -- : [eca10599-6648-4625-8f09-99be2add3b16] - Working...
E, [2015-08-05T17:39:12.616119 #49511] ERROR -- : Actor crashed!
RuntimeError: BOOM
    simple_poc.rb:18:in `block in work'
I, [2015-08-05T17:39:12.617089 #49511]  INFO -- : [d4534e4e-0d36-41fb-8d92-2b3744314eee] - Working...
E, [2015-08-05T17:39:12.617210 #49511] ERROR -- : Actor crashed!
RuntimeError: BOOM
    simple_poc.rb:18:in `block in work'
I, [2015-08-05T17:39:12.617893 #49511]  INFO -- : [bda39ba0-1cc6-41f9-94b2-83bb72c6bc03] - Working...
I, [2015-08-05T17:39:13.619554 #49511]  INFO -- : [bda39ba0-1cc6-41f9-94b2-83bb72c6bc03] - Working...
D, [2015-08-05T17:39:14.596879 #49511] DEBUG -- : Terminating task: type=:call, meta={:dangerous_suspend=>false, :method_name=>:work}, status=:sleeping
    Celluloid::Task::Fibered backtrace unavailable. Please try `Celluloid.task_class = Celluloid::Task::Threaded` if you need backtraces here.
D, [2015-08-05T17:39:14.597275 #49511] DEBUG -- : Terminating 1 actor...
```

(Backtraces trimmed for brevity).

## Conclusion

`Celluloid` is a very big framework, with an even bigger ecosystem. It powers well known ruby projects like *Sidekiq*. The above example just scratched the surface and exposes a common use I have. But, please do take a look at the [wiki][3] for more features.

Working with Actor-based framework, is in some ways different than traditional ruby, but it also fits in nicely. It may be because I was already primed by reading about Elixir and OTP lately, but I found it somewhat liberating to not have to think about all possible errors conditions and just focus on the happy path, with the confidence that any error will be automatically recovered from.

[1]: https://celluloid.io/
[2]: /categories/elixir/
[3]: https://github.com/celluloid/celluloid/wiki
