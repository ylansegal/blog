# on.code && such

Source for my personal blog at [ylan.segal-family.com](https://ylan.segal-family.com).

## Technical Overview

- **Engine:** [Jekyll 4.1](https://jekyllrb.com/)
- **Theme:** [Whiteglass](https://github.com/yous/whiteglass) (customized)
- **Hosting:** [NearlyFreeSpeech.NET](https://www.nearlyfreespeech.net/)
- **Ruby:** 3.4.1 (managed via `.tool-versions` for asdf/mise)

## Local Development

### Prerequisites

- Ruby 3.4.1
- Bundler

### Setup

```bash
bundle install
```

### Common Commands

```bash
# Build the site
make build

# Build with drafts included
make build_with_drafts

# Serve locally
bundle exec jekyll serve

# Create a new post
bin/new_post "Post Title Here"
```

## Content Management

### Blog Post Format
Posts are written in Markdown and stored in `src/_posts/`. They use YAML front matter:

```yaml
---
layout: post
title: "Post Title"
date: YYYY-MM-DD HH:MM:SS -TTTT
categories:
- category1
excerpt_separator: <!-- more -->
---
```

### Syndicating to Bluesky (POSSE)
This blog follows the **POSSE** (Publish Own Site, Syndicate Elsewhere) philosophy. After a post is live:

```bash
bin/syndicate_to_bluesky src/_posts/YYYY-MM-DD-title.md
```

*Requires `BLUESKY_IDENTIFIER` and `BLUESKY_APP_PASSWORD` environment variables.*

### Diagrams
PlantUML diagrams in `src/_diagrams/*.plantuml` are automatically converted to PNGs in `src/assets/images/diagrams/` during the build.

## Deployment

```bash
# Full deployment (build, test, push to git, rsync to server, purge CDN)
make deploy
```

## Project Structure

- `src/_posts/`: Published blog posts
- `src/_drafts/`: Draft posts
- `src/_layouts/`: Jekyll layouts
- `src/_includes/`: Partial templates
- `src/_diagrams/`: PlantUML source files
- `bin/`: Utility scripts (new_post, syndication)
