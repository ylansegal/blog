---
layout: post
title: "Per-Project environment variables"
date: 2012-09-25 19:59
comments: true
categories:
- unix
- foreman
---

I [wrote before][1] about using [foreman][2] to manage you app's processes. An additional feature is that it enables you to configure your unix environment when starting an app, by reading environment variables
located in a ```.env``` file at the root of your project, that looks something like this:

```shell
MY_VARIABLE=/some/path
SECRET_STUFF=get_a_better_password
```

It is certainly a great feature for setting an common environment for processes that your start with foreman. However, processes that are started manually, like for example a rails console, don't have this environment setup. Of course, you can always set them manually in your shell profile, but now they need to be maintained in two different places.

<!-- more -->

Adding to that problem, I have recently started working on a project that is split up into smaller sub-projects that are in different stages of development. They share some environment variables, which are common to the whole application, but vary during development between sub-projects. Since, I can't be bothered to remember to change the variables each time I am about to work on a sub-project, I came up with a way to solve all my problems at once:

```shell
# Overriding cd function. Looking for .env and sourcing it if found
function cd {
 	builtin cd "$@"
  if [[ -f .env ]]; then
    echo "### Setting up environment variables from .env"
    cat .env | grep -v '#' | while read line; do
      echo $line
      export $line
    done
  fi
}
```

The code above lives inside my shell profile and basically overrides built-in cd function to source each non-comment line from the ```.env``` file (if found) after changing directories. This way, when I change into a sub-project directory my environment is setup for me, and variables are available to foreman and non-foreman processes alike.

*Gotcha:* Since it's unlikely that you want to share the ```.env``` variables with other members of your team, I suggest adding an entry to your global gitignore file.

[1]: http://ylan.segal-family.com/blog/2012/09/03/manage-your-apps-multiple-processes-with-a-procfile/
[2]: https://github.com/ddollar/foreman
