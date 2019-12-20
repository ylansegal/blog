---
layout: post
title: "A Tale Of jRuby Profiling"
date: 2013-02-20 17:16
comments: true
categories:
- jruby
- profiling
---

Recently, I have been working on moving some processes from the request-response web cycle to a [MongoMapper-backed][1] [Delayed::Job][2]. Everything seem to go smoothly, but it seemed that there was some slowness actually queuing the jobs. Here is how I got to the bottom of it.

<!-- more -->

## Benchmarking

First, I wrote a very basic benchmark to see if indeed queuing was slow:

```ruby
require 'benchmark'

class EasyJob
  def perform
  end
end

Benchmark.bm do |x|
  x.report { 100.times { Delayed::Job.enqueue EasyJob.new } }
end
```

Running that resulted in the following output:

```
     user     system      total        real
18.382000   0.000000  18.382000 ( 18.382000)
```
Pushing the simplest job to the queue takes an average of 0.1832 seconds per push. Slow indeed.

## Profiling

To get to the actual source of slowness, I read up on [jRuby Profiling][3]. Note that it is imperative to use set ```JRUBY_OPTS='--profile' for the following to work:

```ruby
require 'jruby/profiler'

class EasyJob
  def perform
  end
end

profile_data = JRuby::Profiler.profile { 100.times { Delayed::Job.enqueue EasyJob.new } }

JRuby::Profiler::FlatProfilePrinter.new(profile_data).printProfile(STDOUT)
```

With the following output:

```
     total        self    children       calls  method
----------------------------------------------------------------
     26.94        0.00       26.94           1  <unknown>
     26.94        0.00       26.93           1  Fixnum#times
     26.93        0.00       26.93         100  Delayed::Backend::Base::ClassMethods#enqueue
     26.83        0.00       26.83        1200  Kernel#send
     26.76        0.00       26.76         600  Proc#call
     26.75        0.00       26.75        3000  Kernel#tap
     26.74        0.00       26.74         100  Delayed::Lifecycle#run_callbacks
     26.74        0.00       26.74         100  Delayed::Callback#execute
     26.74        0.00       26.74         100  MongoMapper::Plugins::IdentityMap#save
     26.74        0.00       26.73         100  MongoMapper::Plugins::Validations#save
     26.72        0.00       26.71         400  MongoMapper::Plugins::EmbeddedCallbacks#run_callbacks
     26.71        0.00       26.71         100  MongoMapper::Plugins::Dirty#save
     26.71        0.00       26.71         100  MongoMapper::Plugins::Dirty#clear_changes
     26.71        0.00       26.71         400  ActiveSupport::Callbacks#run_callbacks
     26.71        0.00       26.71         400  ActiveSupport::Callbacks::ClassMethods#__run_callback
     26.70        0.00       26.70         100  MongoMapper::Plugins::Querying#save
     26.70        0.00       26.70         100  MongoMapper::Plugins::Callbacks#create_or_update
     26.70        0.00       26.70         100  Delayed::Backend::MongoMapper::Job#_run_save_callbacks
     26.69        0.00       26.69         100  <unknown>
     26.26        0.00       26.26         100  MongoMapper::Plugins::Querying#create_or_update
     26.26        0.00       26.26         100  MongoMapper::Plugins::Callbacks#create
     26.25        0.00       26.25         100  Delayed::Backend::MongoMapper::Job#_run_create_callbacks
     26.25        0.00       26.25         100  <unknown>
     26.25        0.00       26.25         100  MongoMapper::Plugins::Querying#create
     26.25        0.00       26.25         100  MongoMapper::Plugins::Safe#save_to_collection
     26.25        0.00       26.25         100  MongoMapper::Plugins::Associations#save_to_collection
     26.25        0.00       26.24         100  MongoMapper::Plugins::Querying#save_to_collection
     26.18        0.00       26.18         100  Mongo::Collection#save
     26.18        0.00       26.17         100  Mongo::Collection#update
     26.13        0.00       26.13         100  Mongo::Logging#instrument
     26.13        0.00       26.13         100  Mongo::Logging::Instrumenter.instrument
     26.13        0.00       26.12         100  Mongo::Networking#send_message_with_gle
     25.93        0.00       25.93         100  Mongo::MongoClient#checkout_writer
     25.93        0.00       25.93         100  Mongo::Pool#checkout
     25.93        0.01       25.92         437  Mutex#synchronize
     25.93        0.00       25.92         100  Kernel#loop
     25.92       25.92        0.00          37  ConditionVariable#wait
      0.35        0.00        0.35         200  Time#==
      0.35        0.00        0.35         200  Time#<=>
      0.35        0.00        0.35         600  Time#compare_with_coercion
      0.29        0.00        0.29         200  DateTime#<=>
      0.29        0.29        0.00         200  BasicObject#method_missing
      0.23        0.00        0.23        4700  Class#new
      0.19        0.00        0.19         100  MongoMapper::Plugins::Sci#initialize
      0.19        0.00        0.18         100  MongoMapper::Plugins::Dirty#initialize
      0.18        0.00        0.18         100  MongoMapper::Plugins::Keys#initialize
      0.16        0.00        0.16         100  Mongo::Networking#receive
      0.13        0.00        0.13         400  Mongo::Networking#receive_message_on_socket
      0.13        0.00        0.13         400  Mongo::Networking#receive_data
      0.13        0.01        0.12         900  MongoMapper::Plugins::Dirty#write_key
```

From the above it's cleat that were we are spending the bulk of the time is in ```ConditionVariable#wait```. From the [documentation][4]:

> ConditionVariable objects augment class Mutex. Using condition variables, it is possible to suspend while in the middle of a critical section until a resource becomes available.

Focusing on the immediate previous calls, we can see that it looks like the ```Mongo::Pool``` is having a hard time with the checkout. Hmm... how many connections are there by default? It turns out, that it's [just 1][5].

After tweaking the Mongo connection url to increase the number of connections (to 5) and running our benchmark again:

```
    user     system      total        real
0.710000   0.000000   0.710000 (  0.710000)
```
Much better.


[1]: https://github.com/thisduck/delayed_job_mongo_mapper
[2]: https://github.com/collectiveidea/delayed_job
[3]: https://github.com/jruby/jruby/wiki/Profiling-jruby
[4]: http://www.ruby-doc.org/stdlib-1.9.3/libdoc/thread/rdoc/ConditionVariable.html
[5]: https://github.com/mongodb/mongo-ruby-driver
