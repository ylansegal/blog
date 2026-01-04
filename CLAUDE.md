# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal blog built with Jekyll 4.1, using the jekyll-whiteglass theme. The blog is published at https://ylan.segal-family.com and hosted on NearlyFreeSpeech.NET. Blog posts are written in Markdown with YAML front matter.

## Development Environment

- Ruby version: 3.4.1 (managed via `.tool-versions` for asdf)
- The `.envrc` file enables YJIT for Ruby performance
- Dependencies are managed via Bundler (see `Gemfile`)
- Jekyll source files are in `src/`, output goes to `_site/`

## Common Commands

### Building and Serving

```bash
# Install dependencies
bundle install

# Build the site
make build

# Build with drafts included
make build_with_drafts

# Serve locally (Jekyll default)
bundle exec jekyll serve

# Clean generated files
make clean
```

### Working with Posts

```bash
# Create a new post
bin/new_post "Post Title Here"
```

This script creates a new post in `src/_posts/` with:
- Proper date-prefixed filename format: `YYYY-MM-DD-title.md`
- YAML front matter template with layout, title, date, categories, and excerpt_separator

### Syndicating to Bluesky (POSSE)

This blog follows the POSSE (Publish Own Site, Syndicate Elsewhere) philosophy - posts are published on the blog first, then syndicated to social media.

```bash
# Syndicate a published post to Bluesky
bin/syndicate_to_bluesky src/_posts/2026-01-04-post-title.md
```

**Setup (one-time):**

1. Create a Bluesky app password:
   - Go to https://bsky.app/settings/app-passwords
   - Click "Add App Password"
   - Give it a name (e.g., "Blog Syndication")
   - Copy the generated password

2. Set environment variables (add to `~/.bashrc`, `~/.zshrc`, or `.envrc`):
   ```bash
   export BLUESKY_IDENTIFIER='your-handle.bsky.social'
   export BLUESKY_APP_PASSWORD='your-app-password-here'
   ```

**Workflow:**

1. Write and deploy your post:
   ```bash
   bin/new_post "My Post Title"
   # ... write content ...
   make deploy
   ```

2. Syndicate to Bluesky (after post is live):
   ```bash
   bin/syndicate_to_bluesky src/_posts/2026-01-04-my-post-title.md
   ```

   The script will:
   - Show you a preview of the Bluesky post
   - Ask for confirmation
   - Post to Bluesky with a link back to your blog
   - Update the post's front matter with syndication metadata

3. Deploy the updated metadata:
   ```bash
   git add src/_posts/2026-01-04-my-post-title.md
   git commit -m "Add Bluesky syndication link"
   make deploy
   ```

**Front Matter with Syndication:**

After syndication, posts will have a `syndicated` field added:

```yaml
---
layout: post
title: "Post Title"
date: 2026-01-04 10:00:00 -0800
categories:
- ruby
excerpt_separator: <!-- more -->
syndicated:
- platform: bluesky
  url: https://bsky.app/profile/you.bsky.social/post/xyz123
  date: 2026-01-04 10:05:00 -0800
---
```

### Deployment

```bash
# Deploy to production (builds, tests, pushes to git, rsyncs to server)
make deploy

# Deploy with drafts
make deploy_with_drafts

# Test for broken links (requires local server running)
make test
```

The deployment process:
1. Builds the site
2. Runs link checker against local server (http://127.0.0.1:4000)
3. Pushes to git origin/master
4. Rsyncs `_site/` to NearlyFreeSpeech.NET via SSH
5. Purges CDN cache with curl
6. Opens the live site

### Working with Diagrams

PlantUML diagrams in `src/_diagrams/*.plantuml` are automatically converted to PNG images in `src/assets/images/diagrams/` during the build process.

```bash
# Generate diagrams (happens automatically during build)
make diagrams
```

### Log Analysis

```bash
# Download logs from server
make logs

# Generate traffic report with goaccess
# Creates logs/report.html from access logs
make analyze-logs
```

## Project Structure

- `src/_posts/`: Published blog posts in Markdown
- `src/_drafts/`: Draft posts (not published unless using build_with_drafts)
- `src/_layouts/`: Custom Jekyll layouts (home.html, post.html)
- `src/_includes/`: Reusable Jekyll includes/partials
- `src/_diagrams/`: PlantUML source files for diagrams
- `src/assets/`: Static assets (images, CSS, etc.)
- `src/_data/`: Jekyll data files
- `_site/`: Generated static site (git-ignored)
- `bin/new_post`: Script to create new posts
- `bin/syndicate_to_bluesky`: Script to syndicate posts to Bluesky
- `logs/`: Server access logs (downloaded via rsync)

## Blog Post Format

Posts use YAML front matter:

```yaml
---
layout: post
title: "Post Title"
date: YYYY-MM-DD HH:MM:SS -TTTT
categories:
- category1
- category2
excerpt_separator: <!-- more -->
---
```

The excerpt separator controls what appears in post listings vs. the full post view.

## Configuration

- Jekyll configuration: `_config.yml`
- Site source directory is set to `src/`
- Permalinks use format: `/blog/:year/:month/:day/:title/`
- Pagination enabled (5 posts per page)
- RSS feed available at `/atom.xml` (via jekyll-feed)
- Archives generated for categories and tags
