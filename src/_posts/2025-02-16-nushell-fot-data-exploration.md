---
layout: post
title: "Nushell fot Data Exploration"
date: 2025-02-16 11:44:08 -0800
categories:
- nushell
- unix
excerpt_separator: <!-- more -->
---

I recently discovered [Nushell][nu]. It's billed as a "new kind of shell". What caught my eye is not so much the actual shell usage: Executing commands, redirecting output, working with files, etc. I was interested in the concept of structured data:

> Everything is data

> Nu pipelines use structured data so you can safely select, filter, and sort the same way every time. Stop parsing strings and start solving problems.

Nushell comes with support for a variety of formats (e.g. `JSON`, `YAML`, `csv`):

```
> open package.json | get dependencies
╭──────────────────────────────────┬─────────────╮
│ @fontsource-variable/caveat      │ ^5.1.0      │
│ @fontsource-variable/raleway     │ ^5.1.0      │
│ @fortawesome/fontawesome-free    │ ^6.7.2      │
│ @hotwired/turbo-rails            │ ^8.0.12     │
│ @popperjs/core                   │ ^2.11.8     │
│ @rails/actioncable               │ ^8.0.100    │
│ @rails/activestorage             │ ^8.0.100    │
│ @rails/ujs                       │ ^7.1.3-4    │
│ @ttskch/select2-bootstrap4-theme │ ^1.5.2      │
│ autoprefixer                     │ ^10.4.20    │
│ bootstrap                        │ ^4.5.3      │
│ esbuild                          │ ^0.19.3     │
│ jquery                           │ 3.7.1       │
│ nodemon                          │ ^3.1.9      │
│ popper.js                        │ ^1.15.0     │
│ postcss                          │ ^8.4.30     │
│ postcss-cli                      │ ^10.1.0     │
│ sass                             │ ^1.67.0     │
│ select2                          │ ^4.1.0-rc.0 │
│ startbootstrap-sb-admin          │ ^6.0.2      │
╰──────────────────────────────────┴─────────────╯
```

Pipes can be built up:

```
> open package.json | get dependencies | transpose | where column0 =~ @rails
╭───┬──────────────────────┬──────────╮
│ # │       column0        │ column1  │
├───┼──────────────────────┼──────────┤
│ 0 │ @rails/actioncable   │ ^8.0.100 │
│ 1 │ @rails/activestorage │ ^8.0.100 │
│ 2 │ @rails/ujs           │ ^7.1.3-4 │
╰───┴──────────────────────┴──────────╯
```

Converting between formats is a breeze:

```
> open package.json | get dependencies | to yaml
'@fontsource-variable/caveat': ^5.1.0
'@fontsource-variable/raleway': ^5.1.0
'@fortawesome/fontawesome-free': ^6.7.2
'@hotwired/turbo-rails': ^8.0.12
'@popperjs/core': ^2.11.8
'@rails/actioncable': ^8.0.100
'@rails/activestorage': ^8.0.100
'@rails/ujs': ^7.1.3-4
'@ttskch/select2-bootstrap4-theme': ^1.5.2
autoprefixer: ^10.4.20
bootstrap: ^4.5.3
esbuild: ^0.19.3
jquery: 3.7.1
nodemon: ^3.1.9
popper.js: ^1.15.0
postcss: ^8.4.30
postcss-cli: ^10.1.0
sass: ^1.67.0
select2: ^4.1.0-rc.0
startbootstrap-sb-admin: ^6.0.2
```

And there is a built in `explore` TUI command that you can pipe data to (`open file.csv | explore`) to drill in and out of data interactively. Lovely.

I'm just getting started with Nushell, but already seems like a useful tool to have for data exploration and transformation.

[nu]: https://www.nushell.sh
