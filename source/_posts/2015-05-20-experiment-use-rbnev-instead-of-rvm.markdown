---
layout: post
title: "Experiment: Use rbnev instead of rvm"
date: 2015-05-20 08:51:50 -0700
comments: true
categories:
- experiment
- ruby
---

I have been using `rvm` to manage my rubies for almost 5 years, mostly without problems. Throughout the years though, the number of features added keeps going in an attempt to do more for the user. Two weeks ago I was dealing with a cryptic stack trace related to X509 certificates when doing some cryptographic operations in JRuby 1.7.19. I wasn't really sure what the culprit was, but the [rvm documentation][1] suggest that `rvm` itself can fix the issue. That seemed weird to me and also, it didn't work. I was stuck with a JRuby installation that could not read the certificate from *https://www.google.com*.

## Methodology

Under the assumption that the culprit of my problem was `rvm`, I decided that try one of the alternatives: `rbenv`. Luckily this is a blog, because when speaking the name of the two tools sound infuriatingly similar. Switching to `rbenv` was relatively easy. The steps I followed are those outlined in [brentertz][2] gist:

<script src="https://gist.github.com/brentertz/1384279.js"></script>

Installing rubies was straight forward. I usually need a few versions of MRI on hand, going back to 1.9.3 and JRuby as well. All were installed without problems and worked fine.

My team had some scripts that assumed `rvm` was installed, but it was trivial to add support for `rbenv`, like so:

``` bash
if which rvm &> /dev/null; then
  rvm --create use ${version}
fi
if which rbenv &> /dev/null; then
  rbenv shell ${version}
fi
```

In addition, I like having the current ruby version in my prompt, because I switch between versions often, even while working on the same project. My custom zsh theme needed to be adjusted as well. Using the same trick as above, I created a bash function that does the right thing:

``` bash
# Somewhere that gets sourced on shell init.. like .profile
ruby_version()
{
  if which rbenv &> /dev/null; then
    rbenv version | cut -f1 -d ' '
  else
    if which rvm-prompt &> /dev/null; then
     rvm-prompt i v g
    fi
  fi
}
```

### Results

Most of our projects have been around for a while, so they are setup to use gemsets, because that was what `rvm` encouraged (and maybe still does, I don't know). `rbenv`'s philosophy, on the other hand, is that they are unnecessary when using bundler. So far, not using gemsets has not had negative effects for me. I also have noted that my shell feels snappier when navigating directories: I attribute that to `rvm` hooking into `cd`, which is not done by `rbenv`.

So far, I gave been happy with `rbenv` and believe that it is a simpler tool that does enough for the job at hand, but no more. And remember that X509 issue? It turns out it was not really related to `rvm` at all: It was caused by duplicate certificates derived from the OSX keychain that where being picked up by JRuby and the underlying Java classes objected to. That issue got solved by getting certs from the `curl` website and pointing JRuby to use those.

[1]: https://rvm.io/support/fixing-broken-ssl-certificates
[2]: https://github.com/brentertz
