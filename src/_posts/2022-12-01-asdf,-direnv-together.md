---
layout: post
title: "Asdf, Direnv Together"
date: 2022-12-01 18:05:26 -0800
categories:
- unix
- asdf
- direnv
excerpt_separator: <!-- more -->
---

I previously wrote about how I use [asdf][asdf] and [dirvenv][dirvenv] together to setup [per-project postgres versions][per-postgres]. I recently learned about [asdf-direnv][asdf-direnv], a `direnv` plugin for `asdf`.

`asdf` works by creating [shims][shims] of every executable. This adds some overhead. The plugin works by leveraging `direnv` to change the `PATH` to the actual executable, instead of the shim.

## Results

I use `asdf` to install most versions that I want to control precisely for my projects. Usually, this means the `ruby` and `postgres` version. Let's time the performance without using `asdf-direnv`:

```
$ which ruby
/Users/ylansegal/.asdf/shims/ruby

$ time ruby -e "puts 'hello'"
hello
ruby -e "puts 'hello'"  0.04s user 0.02s system 38% cpu 0.155 total


$ which psql
/Users/ylansegal/.asdf/shims/psql

$ time psql -c 'select now()'
              now
-------------------------------
 2022-11-28 17:01:07.470615-08
(1 row)

Time: 0.142 ms
psql -c 'select now()'  0.01s user 0.01s system 12% cpu 0.129 total
```

Installing `asdf-direnv` is straight forward, as listed in the [documentation][asdf-direnv]. Once enabled in my `.envrc` file:

```
$ cat .envrc
use asdf
watch_file ".ruby-version"
```

We can see the performance gains:

```
$ which ruby
/Users/ylansegal/.asdf/installs/ruby/3.0.4/bin/ruby

$ time ruby -e "puts 'hello'"
hello
ruby -e "puts 'hello'"  0.04s user 0.02s system 93% cpu 0.065 total

$ which psql
/Users/ylansegal/.asdf/installs/postgres/13.5/bin/psql

$ time psql -c 'select now()'
              now
-------------------------------
 2022-11-28 17:01:42.357192-08
(1 row)

Time: 0.195 ms
psql -c 'select now()'  0.00s user 0.00s system 56% cpu 0.012 total
```

| Command | With shim (s) | Without shim (s) |
| ------- | ------------- | ---------------- |
| ruby    | 0.155         | 0.065            |
| psql    | 0.129         | 0.012            |

In both cases, the savings are ~90 ms. It's commonly said that anything below 200 ms is acceptable UX as "immediate". To me, my terminal feels **much** snappier.

I've been using this setup for a few weeks. The only issue I've encountered was that the plugin seems to fail to pickup the occasional changes in `.ruby-toolbox` even though the documentation states that `watch_file` in the documentation should fix that. I've been able to work around that by with `touch .envrc`, which forces the `PATH` to be re-calculated.



[asdf]: https://asdf-vm.com/
[dirvenv]: https://direnv.net/
[per-postgres]: {% post_url 2021-07-23-per-project-postgres-with-asdf-and-direnv %}
[asdf-direnv]: https://github.com/asdf-community/asdf-direnv
[shims]: https://en.wikipedia.org/wiki/Shim_(computing)
