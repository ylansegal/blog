---
layout: post
title: "Git: Amend any commit"
date: 2025-11-15 14:15:17 -0800
categories:
- git
- productivity
excerpt_separator: <!-- more -->
---

I recently read [The (lazy) Git UI You Didn't Know You Need](https://www.bwplotka.dev/2025/lazygit/) and experimented with `lazygit`. My usual workflow involves invoking `git` directly, staging commits with `git add` and `git add -p`, often selecting files using a [fuzzy finder][1]. The article highlighted `lazygit`'s ability to amend *any* commit, not just the most recent one, which sparked an idea.

## Current Workflow for Amending Commits

To amend a commit, I first stage the changes. Then, when I want to amend the last commit, I use:

```
$ git commit --amend
```

This opens my editor with the previous commit message, which I usually accept and close without change.

Amending a *previous* commit is more involved. After staging the changes I:

```
$ git commit --fixup <sha>
```
(The sha is typically picked through fuzzy finding as well).

Then I rebase to actually apply the fixup those two commits:

```
$ git rebase -i --autosquash <earlier-sha>
```

The `<earlier-sha>` is also selected with a fuzzy finder, and must be a commit prior to the one being fixed.

I think we can do better.

## git-fix

I realized much of this could be automated. I prompted an agent to create a script for me that would do the following:

```
# Amends the last commit with staged changes
$ git fix
# Amends the specific commit with staged changes
$ git fix <sha>
```

What about conflicts? Abort and leave the repo in the same state as it was before the command.

I also instructed it to use TDD, which I believe effectively guided the agent.

Specs:
```ruby
require "spec_helper"
require "open3"
require "tmpdir"
require "fileutils"

RSpec.describe "git-fix" do
  let(:script_path) { File.expand_path("../settings/.bin/git-fix", __dir__) }

  around do |example|
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        # Initialize a git repo
        system("git init --quiet")
        system("git config user.email 'test@example.com'")
        system("git config user.name 'Test User'")
        system("git config commit.gpgsign false")

        example.run
      end
    end
  end

  it "amends a commit with staged changes" do
    # Create initial commit
    File.write("file.txt", "line 1\n")
    system("git add file.txt")
    system("git commit --quiet -m 'Initial commit'")

    # Create a second commit that we'll want to fix
    File.write("file.txt", "line 1\nline 2\n")
    system("git add file.txt")
    system("git commit --quiet -m 'Add line 2'")
    target_commit = `git rev-parse HEAD`.strip

    # Now we want to fix the second commit (no commits after it)
    File.write("file.txt", "line 1\nline 2 fixed\n")
    system("git add file.txt")

    # Run git-fix
    output, status = Open3.capture2e(script_path, target_commit)

    expect(status.success?).to be(true), "Command failed with output: #{output}"

    # Verify the commit was amended
    fixed_content = `git show HEAD:file.txt`
    expect(fixed_content).to eq("line 1\nline 2 fixed\n")

    # Verify commit count is still 2
    commit_count = `git rev-list --count HEAD`.strip.to_i
    expect(commit_count).to eq(2)
  end

  it "works with short commit references" do
    # Create initial commit
    File.write("file.txt", "initial\n")
    system("git add file.txt")
    system("git commit --quiet -m 'Initial'")

    # Create target commit
    File.write("file.txt", "initial\nv1\n")
    system("git add file.txt")
    system("git commit --quiet -m 'Add v1'")
    target_commit = `git rev-parse --short HEAD`.strip

    # Stage a fix
    File.write("file.txt", "initial\nv1 fixed\n")
    system("git add file.txt")

    # Run git-fix with short SHA
    output, status = Open3.capture2e(script_path, target_commit)

    expect(status.success?).to be true
    expect(File.read("file.txt")).to eq("initial\nv1 fixed\n")
  end

  it "amends a middle commit when changes don't overlap" do
    # Create initial commit with two files
    File.write("file1.txt", "content 1\n")
    File.write("file2.txt", "content 2\n")
    system("git add .")
    system("git commit --quiet -m 'Initial commit'")

    # Modify file1 in second commit
    File.write("file1.txt", "content 1 modified\n")
    system("git add file1.txt")
    system("git commit --quiet -m 'Modify file1'")
    target_commit = `git rev-parse HEAD`.strip

    # Modify file2 in third commit (different file, no overlap)
    File.write("file2.txt", "content 2 modified\n")
    system("git add file2.txt")
    system("git commit --quiet -m 'Modify file2'")

    # Now fix the second commit (file1)
    File.write("file1.txt", "content 1 fixed\n")
    system("git add file1.txt")

    output, status = Open3.capture2e(script_path, target_commit)

    expect(status.success?).to be(true), "Command failed with output: #{output}"

    # Verify both files have correct content
    expect(File.read("file1.txt")).to eq("content 1 fixed\n")
    expect(File.read("file2.txt")).to eq("content 2 modified\n")

    # Verify commit count is still 3
    commit_count = `git rev-list --count HEAD`.strip.to_i
    expect(commit_count).to eq(3)
  end

  it "defaults to HEAD when no commit is specified" do
    # Create initial commit
    File.write("file.txt", "line 1\n")
    system("git add file.txt")
    system("git commit --quiet -m 'Initial commit'")

    # Create second commit
    File.write("file.txt", "line 1\nline 2\n")
    system("git add file.txt")
    system("git commit --quiet -m 'Add line 2'")

    # Stage changes to fix the last commit (HEAD)
    File.write("file.txt", "line 1\nline 2 fixed\n")
    system("git add file.txt")

    # Run git-fix without specifying commit (should default to HEAD)
    output, status = Open3.capture2e(script_path)

    expect(status.success?).to be true

    # Verify the last commit was amended
    expect(File.read("file.txt")).to eq("line 1\nline 2 fixed\n")

    # Verify commit count is still 2
    commit_count = `git rev-list --count HEAD`.strip.to_i
    expect(commit_count).to eq(2)
  end

  it "shows error when nothing is staged" do
    File.write("file.txt", "content\n")
    system("git add file.txt")
    system("git commit --quiet -m 'Initial'")
    target_commit = `git rev-parse HEAD`.strip

    output, status = Open3.capture2e(script_path, target_commit)

    expect(status.success?).to be false
    expect(output).to match(/nothing.*staged/i)
  end

  it "aborts rebase and restores staged changes on conflict" do
    # Create initial commit
    File.write("file.txt", "line 1\n")
    system("git add file.txt")
    system("git commit --quiet -m 'Initial commit'")

    # Create second commit
    File.write("file.txt", "line 1\nline 2\n")
    system("git add file.txt")
    system("git commit --quiet -m 'Add line 2'")
    target_commit = `git rev-parse HEAD`.strip

    # Create third commit that modifies the same line
    File.write("file.txt", "line 1\nline 2 modified\n")
    system("git add file.txt")
    system("git commit --quiet -m 'Modify line 2'")

    # Try to fix the second commit with a conflicting change
    File.write("file.txt", "line 1\nline 2 different fix\n")
    system("git add file.txt")

    # Run git-fix (this should fail due to conflict)
    output, status = Open3.capture2e(script_path, target_commit)

    expect(status.success?).to be false
    expect(output).to match(/conflict/i)
    expect(output).to match(/aborted/i)

    # Verify we're not in the middle of a rebase
    expect(Dir.exist?(".git/rebase-merge")).to be false
    expect(Dir.exist?(".git/rebase-apply")).to be false

    # Verify the fixup commit was removed
    last_commit_msg = `git log -1 --pretty=%B`.strip
    expect(last_commit_msg).to eq("Modify line 2")

    # Verify the changes are still staged
    staged_diff = `git diff --cached --name-only`.strip
    expect(staged_diff).to eq("file.txt")

    # Verify the staged content is what we wanted to fix
    staged_content = `git diff --cached file.txt`
    expect(staged_content).to include("-line 2 modified")
    expect(staged_content).to include("+line 2 different fix")
  end
end
```

Code:
```shell
#!/usr/bin/env bash
# Amends the referenced commit with the code currently staged
# Usage:
#   git fix [commit-sha-reference]
#
# If no commit reference is provided, defaults to HEAD (the last commit).
#
# This script uses git's --fixup and --autosquash features to amend a commit
# in your history. It works best when the changes don't overlap with subsequent
# commits. If there are conflicts during the rebase, you'll need to resolve them
# manually.

set -euo pipefail

# Default to HEAD if no commit reference is provided
commit_ref="${1:-HEAD}"

# Check if there are staged changes
if git diff --cached --quiet; then
  echo "Error: Nothing is staged. Stage your changes with 'git add' first." >&2
  exit 1
fi

# Resolve the commit reference to a SHA before creating the fixup
# This is important because creating the fixup will change where HEAD points
target_commit=$(git rev-parse "$commit_ref")

# Create a fixup commit
git commit --fixup="$target_commit"

# Get the parent of the target commit to use as rebase base
rebase_base=$(git rev-parse "$target_commit^")

# Rebase with autosquash (non-interactive)
# If the rebase fails, we need to clean up
if ! GIT_SEQUENCE_EDITOR=: git rebase --autosquash -i "$rebase_base" 2>&1; then
  echo "" >&2
  echo "Error: Rebase failed due to conflicts." >&2
  echo "Aborting rebase and restoring your staged changes..." >&2

  # Abort the rebase
  git rebase --abort

  # Uncommit the fixup commit but keep changes staged
  git reset --soft HEAD~1

  echo "Aborted. Your changes are still staged." >&2
  echo "Please resolve conflicts manually or modify your changes." >&2
  exit 1
fi
```

After only a few days of use, I can already see me using this regularly.

[1]: {% post_url 2025-03-16-how-im-productive-in-the-command-line %}
