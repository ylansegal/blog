---
layout: post
title: "Testing With Multiple Ruby And Gem Versions"
date: 2013-06-21 09:25
comments: true
categories: 
- rvm
- rspec
---

I found myself writting a gem for internal use that needed to run in several different ruby versions and MRI. In addition, the projects that it would be used in had other dependencies which also meant that it would need to function with different versions of dependencies. Here is how I ensured I was testing all scenarios.

<!-- more -->

## Testing Multiple Ruby Versions

I started by leveraging [rvm][1], which I use to manage multiple ruby versions on my development machine.

``` bash 
#!/usr/bin/env bash

set -e

rubies=("ruby-2.0.0" "ruby-1.9.3" "jruby-1.6.7.2" "jruby-1.7.3")
for i in "${rubies[@]}"
do
  echo "====================================================="
  echo "$i: Start Test"
  echo "====================================================="
  rvm $i exec bundle
  rvm $i exec bundle exec rspec spec
  echo "====================================================="
  echo "$i: End Test"
  echo "====================================================="
done
```

The script basically just runs rspec on several versions of ruby. I used `set -e` to stop execution of the script if any commands has an exit code different than 0.

## Testing Multiple Gem Versions

The next piece of the puzzle is the [Appraisal gem][2] from the guys at [thoughbot][3]. This gem lets you test your gem against different versions of dependencies. It is really elegant, and the instructions on the project page are really easy to follow. My *Appraisals* files like:

``` ruby
appraise "oauth2-latest-release" do
  gem "oauth2"
end

appraise "oauth2-0.4" do
  gem "oauth2", '0.4.1'
end
```

## All Together Now

As a last step, I just modified my first script to use appraisals, so I now run all gem dependency variations against all rubies. 

``` bash
#!/usr/bin/env bash

set -e

rubies=("ruby-2.0.0" "ruby-1.9.3" "jruby-1.6.7.2" "jruby-1.7.3")
for i in "${rubies[@]}"
do
  echo "====================================================="
  echo "$i: Start Test"
  echo "====================================================="
  rvm $i exec bundle install
  rvm $i exec rake appraisal:install
  rvm $i exec rake appraisal
  echo "====================================================="
  echo "$i: End Test"
  echo "====================================================="
done
```

Simple, yet effective.

[1]: https://rvm.io/
[2]: https://github.com/thoughtbot/appraisal
[3]: http://www.thoughtbot.com/