---
layout: post
title: "DelayedJob Workers Are Not Thread Safe"
date: 2013-09-11 21:07
comments: true
categories:
- jruby
- delayed_job
- threading
- most_popular
---

I love [DelayedJob][1]. It's my go-to-gem for background processing in Rails, mainly because it works with whatever
data store your project already has in place. No need to bring a different dependency just for background processing. However, using `Delayed::Worker` in threads is problematic.

<!-- more -->

# The Setup

I work with jRuby often, as it's [often discussed][2] on this blog. We have been using delayed job for background processing for a while now. Because our deployment is in the form of a war file deployed to a tomacat instance, it's much easier to manage threads on the same JVM, than to use separate UNIX processes. We start DelayedJon in a Rails initializer:

``` ruby
Thread.new {
  Delayed::JRubyWorker.new.start  
}
```

The [jRubyWorker][3] inherits most of it's behavior from Delayed::Worker, but leverages some specifics of the JVM and makes some accommodations for threads instead of processes.

(The above code is simplified a bit for illustration purposes. Any exception thrown in the worker connecting to the database would otherwise kill the thread silently. I added some code to harden the thread and restart dead workers).

# The Problem

At some point, we decided to leverage DelayedJob's support for named queues to better split up the workload.

``` ruby
Thread.new {
  Delayed::JRubyWorker.new({ :queues => ['main'] }).start  
}

Thread.new {
  Delayed::JRubyWorker.new({ :queues => ['events'] }).start
}
```

My expectation is that I would have one worker dedicated to jobs in the *main* queue and another worker for *events*. In reality, what we had was two workers for *events* and an ever-growing *main* queue.

# The Cause

After much hair-pulling, I found the following code in Delayed::Worker:

``` ruby
module Delayed
  class Worker

    def initialize(options={})
      @quiet = options.has_key?(:quiet) ? options[:quiet] : true
      @failed_reserve_count = 0

      [:min_priority, :max_priority, :sleep_delay, :read_ahead, :queues, :exit_on_complete].each do |option|
        self.class.send("#{option}=", options[option]) if options.has_key?(option)
      end

      self.plugins.each { |klass| klass.new }
    end
  end
end
```

Initializing an instance of `Worker` sets options, not on that instance, but for ALL instances. The dreaded global state that is the source of so many problems while working with threads.

To be fair, it is clear from the rest of the DelayedJob model that the assumption is that workers will run in a separate process than the rest of the application. That is why `jRubyWorker` has to change the way the worker defines it's name. `Worker` assumes that using the process id will give you uniqueness. In a threading model, it obviously won't.

# The Solution

My first instinct was to just make the options a property of each worker. However, it's not that easy: DelayedJob has several different back-ends (For ActiveRecord, MongoMapper, etc). Each of those need to be changed, because they read the options from the `Worker` class and not the instance.

I believe that there is nothing fundamentally wrong with DelayedJob and it could certainly be made to work with threads be removing the global state. However, it would break compatibility with existing back-end implementations, so it's a little bit more involved than a pull request. I tried contacting the authors on the [mailing list][4], but so far it looks like my post has not been approved by the moderator.

[1]: https://github.com/collectiveidea/delayed_job
[2]: /categories/jruby/
[3]: https://github.com/kares/jruby-rack-worker/blob/master/src/main/ruby/delayed/jruby_worker.rb
[4]: https://groups.google.com/forum/#!forum/delayed_job
