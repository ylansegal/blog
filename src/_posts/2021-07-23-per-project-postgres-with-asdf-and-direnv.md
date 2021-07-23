---
layout: post
title: "Per-project Postgres with asdf and direnv"
date: 2021-07-23 11:46:03 -0700
categories:
- asdf
- direnv
- postgres
- unix
excerpt_separator: <!-- more -->
---

My development computer typically has a number of different projects, each needing specific versions of some tools. [Previously][1], I wrote about using `asdf` to manage my ruby, elixir, crystal and erlang version. I've been using it successfully to manage Postgres versions as well.

## What I get

- Precisely manage the Postgres version (e.g. `10.14`, `12.5`) for each project.
- The Postgres data directory lives alongside other project files
- No collision between projects. Each can have their own Postgres server running simultaneously.

<!-- more -->

## How

I use [asdf](https://asdf-vm.com/#/) and [asdf-postgres](https://github.com/smashedtoatoms/asdf-postgres) to install and manage Postgres. After installing and setting up, I select the version of Postgres by creating a `.tool-versions` file in the root of the project:

```
# .tool-versions
postgres 10.14
```

This directs the Postgres installation to use `10.14`:

```
$ psql --version
psql (PostgreSQL) 10.14
```

Postgres servers by default are configure to open port `5432`. Running multiple Postgres servers would cause collision, and require picking different ports. Instead of assigning a new port number to each server, I direct Postgres to use Unix sockets instead.

In order to automate the needed setup, I use [direnv](https://direnv.net/). I use a custom layout function for Postgres that takes care of setting up Postgres correctly, in `~/.direnvrc`:

```
#!/usr/bin/env bash
# direnv customization

# Initializes per-project postgres
layout_postgres() {
  PGDATA="$(direnv_layout_dir)/postgres"
  PGHOST="$PGDATA"
	export PGDATA PGHOST

	if [[ ! -d "$PGDATA" ]]; then
    log_status "Initializing postgres for this project..."
		initdb
		cat >> "$PGDATA/postgresql.conf" <<-EOF
			listen_addresses = ''
			unix_socket_directories = '$PGHOST'
		EOF
		echo "CREATE DATABASE $USER;" | postgres --single -E postgres
	fi
}
```

On first use for a project, it will create a the needed directories, and configure Postgres to *not* listen on any IP address. It also configures where to look for Unix sockets.

Note that the `direnv_layout_dir` is typically `.direnv` under the project. That means that the Postgres data will leave in `.direnv/postgres`.

To invoke on each project, I add a `.envrc` file:

```
# .envrc
layout postgres
```

The first time `direnv` sees the file, it will prompt to use `direnv allow`. On subsequent invocations, it will only setup the correct environment variables.

The last part, is to start the server. It could be automated, but I typically start myself as needed on each project with:

```
$ pg_ctl status || pg_ctl start
```

You can start as many Postgres servers as you need. I don't see much performance impact on my machine, even with ~5 servers running.

Rails configuration will respect that `PGDATA` and `PGHOST`, and will work seamlessly. Here is what my current `config/database.yml` looks like:

```yml
login: &login
  adapter: postgresql

# For local servers
development:
  <<: *login
  database: my_project_development

test:
  <<: *login
  database: my_project_test
```

As expected, `psql` also respects the environment variables:

```
$ psql my_project_development -c 'SELECT NOW()'
              now
-------------------------------
 2021-07-23 12:01:16.886723-07
(1 row)

Time: 0.365 ms
```

## Conclusion

This setup allows me to manage the version of Postgres on a per-project basis, with minimal setup. It requires a bit of `direnv` customization, and then to opt-in on each project by configuring `asdf` and `direnv`:

```
# .tool-versions
postgres 10.14
```

```
# .envrc
layout postgres
```

`asdf` and `direnv` play well together, even though neither has specific knowledge of the other. The Unix dream.

[1]: /blog/2018/10/26/managing-versions-with-asdf/
