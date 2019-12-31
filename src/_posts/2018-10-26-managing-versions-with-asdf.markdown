---
layout: post
title: "Managing Versions With asdf"
date: 2018-10-26 14:44:04 -0700
comments: true
categories:
- ruby
- asdf
- elixir
---

[Three years ago][1], I switched my ruby version manager from `rvm` to `rbenv`. Since then, I've been using `rbenv` without complaint. It just works. I now find myself working on more complex projects, that needs specific version of Ruby, Elixir, Postgres, Terraform and others.

`asdf` [bills itself][2] as an extendible version manager. It has support for every tool I've needed to install (so far!). It has an extendible plugin system, for those that want to add even more tools. The `asdf-ruby` plugin is very similar to `rbenv`, and uses `ruby-build` under the hood to install rubies. So far, I haven't had any issues.

Currently, I am using the following plugins:

```
$ asdf plugin-list
crystal
elixir
erlang
kubectl
postgres
ruby
terraform
```

Each plugin manages it's own versions:

```
$ asdf list ruby
  2.4.3
  2.4.5
  2.5.1
  2.5.3
```

Selecting versions can be done either with `.tool-versions` file, on a per-project basis:

```bash
# .tool-versions
erlang 21.0.9
elixir 1.7.3
```

or through environment variables:

```bash
$ export ASDF_KUBECTL_VERSION=1.10.3
```

It has support for traditional (or legacy) version files like `.ruby-version`, but I have yet to enable it.

A nice touch is that if a `.tool-versions` is present, `asdf` will install any missing tool, if needed:

```bash
$ asdf install
erlang 21.0.9 is already installed
elixir 1.7.3 is already installed
```

So far, I've found `asdf` a great way to manage complex dependencies on a per-project basis.

[1]: /blog/2015/05/20/experiment-use-rbnev-instead-of-rvm/
[2]: https://github.com/asdf-vm/asdf
