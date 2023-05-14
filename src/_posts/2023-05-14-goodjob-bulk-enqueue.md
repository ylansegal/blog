---
layout: post
title: "GoodJob Bulk Enqueue"
date: 2023-05-14 11:32:29 -0700
categories:
- good_job
- rails
- ruby
excerpt_separator: <!-- more -->
---

# GoodJob Bulk Enqueue

A common pattern in Rails application to queue similar jobs for a collection objects. For example:


```ruby
post.watchers.find_each do |user|
  NotifyOfChanges.perform_later(user, post)
end
```

The above will generate 1 `INSERT` SQL statement for each job queued. I recently noticed that GoodJob introduced a [bulk enqueue feature][bulk]. It allows using a single `INSERT` statement for all those jobs, similar to Rails's [#insert_all][insert_all]:

```ruby
GoodJob::Bulk.enqueue do
  post.watchers.find_each do |user|
  NotifyOfChanges.perform_later(user, post)
end
```

Let's see what the performance is locally:


```ruby
class NoOpJob < ApplicationJob
  def perform
  end
end

require 'benchmark/ips'

Benchmark.ips do |x|
  x.config(:time => 10, :warmup => 5)


  x.report('Single Inserts') {
    ApplicationRecord.transaction do
      500.times { NoOpJob.perform_later }
    end
  }
  x.report('Bulk Inserts') {
    ApplicationRecord.transaction do
      GoodJob::Bulk.enqueue do
        500.times { NoOpJob.perform_later }
      end
    end
  }

  x.compare!
end
```

```
$ rails runner benchmark.rb
Running via Spring preloader in process 46655
Warming up --------------------------------------
      Single Inserts     1.000  i/100ms
        Bulk Inserts     1.000  i/100ms
Calculating -------------------------------------
      Single Inserts      0.833  (± 0.0%) i/s -      9.000  in  10.823196s
        Bulk Inserts      4.746  (± 0.0%) i/s -     48.000  in  10.155956s

Comparison:
        Bulk Inserts:        4.7 i/s
      Single Inserts:        0.8 i/s - 5.70x  slower
```

Locally, we can see a significant performance boost due to fewer round trips to the database. But using bulk enqueue can be even more impactful than that. Production systems typically see much more concurrent load that my local machine. When the queueing is wrapped in a transaction, it can be very disruptive. Long-running transactions can slow the whole system down. Bulk inserting records is a great way to keep transactions short, and the GoodJob feature provides an easy way to do that, while keeping the semantics of the code the same.

[bulk]: https://github.com/bensheldon/good_job#bulk-enqueue
[insert_all]: http://api.rubyonrails.org/classes/ActiveRecord/Persistence/ClassMethods.html#method-i-insert_all
