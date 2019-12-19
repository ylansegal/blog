---
layout: post
title: "Large Teams: Finding A Green Build"
date: 2019-11-05 16:29:34 -0800
comments: true
categories:
- teams
- unix
---

I work on a large engineering team. The main Slack channel for our engineering department has 425 people in it. The code base is split into many repositories, dominated by a big Ruby on Rails application with many contributors. At the time of writing, the last 1,000 commits in `master` on that repository where made by 169 contributors.

The continuous integration for said mono-repo is heavily parallelized but still takes ~30 minutes to complete. Occasionally, a branch is merged that causes the build to fail. Usually, the case is that the specs worked correctly for that branch (otherwise we can't merge), but new changes in `master` are not compatible. As hard as the team tries to maintain a green build (i.e. a build that passes and is deployable), a red build is somewhat frequent.

Branching-off for new work from a commit that is not green guarantees that, later down the line, _your_ branches build will fail, even if your code is nowhere near the failures. The solution is to merge master (hopefully green this by now!), and wait for new builds.

I developed some scar tissue around this. I noticed that I started opening [Circle CI][circle], finding the last green build for the project's workflow, copying the commit hash, and branching-off of that for my work. The results were very positive: I haven't seen failures in one of my branches that are not related to my work since. The process is a bit tedious, though.

Automation to the rescue. Circle CI has an API, but it seems it is suitable to work around builds, while I was interested in whole workflows. However, Circle CI posts it's builds results to GitHub, along with some of the other integrations we use. Github's GraphQL API lets me include the `state` of the last few commits on `master` and find the last one that was successful.

Let's see the commented code:

```ruby
#!/usr/bin/env ruby

# Use bundler, self-contained in the same scrip file, without needing
# a Gemfile and Gemfile.lock
require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "git"
end

require "net/http"
require "json"

# A GitHub token be obtained in github.com
token = ENV.fetch("GITHUB_API_TOKEN")

# Find the GitHub owner and repo from the git remote.
owner, repo =
  Git
  .open(".")
  .remotes
  .first
  .url
  .match(%r{git@github.com:(.*)/(.*).git})
  .captures

# This is my first GraphQL query ever!
# I think I should be able to query only
# for builds with state == SUCCESS
# but I don't know how
query = <<~GRAPHQL
  query {
    repository(owner: \"#{owner}\", name: \"#{repo}\") {
      defaultBranchRef {
        target {
          ... on Commit {
            history(first: 50) {
              nodes {
                oid
                status {
                  state
                }
              }
            }
          }
        }
      }
    }
  }
GRAPHQL

github_url = URI("https://api.github.com/graphql")
headers = { "Authorization" => "bearer #{token}" }
body = { query: query }.to_json

# Send request to GitHub and parse response
response = JSON.parse(Net::HTTP.post(github_url, body, headers).body)

# Find commit nodes
nodes = response.dig("data", "repository", "defaultBranchRef", "target", "history", "nodes")
# Find the first "green" one.
last_build = nodes.find { |node| node.dig("status", "state") == "SUCCESS" }

if last_build
  puts last_build["oid"]
else
  # If we don't have a green build,
  # let's exit with non-zero status
  # to be a good unix citizen
  exit 1
end
```

I named it `git-last-green-commit` and put it in my path, which makes it available for invoking on any project that has a GitHub remote:

```
$ git last-green-build
8f8767ef8e176a851f04fade3fbd11406c084a7a
```

Since it's output is just the commit hash, it can be chained like so:

```
$ git last-green-build | xargs git switch --create my_new_branch

```

Or what I must commonly use:

```
$ git switch master

$ git fetch origin master

$ git last-green-build | xargs git merge

```

Now my local master points to a green build, which I can use to branch-off, rebase, etc.

[circle]: https://circleci.com/
