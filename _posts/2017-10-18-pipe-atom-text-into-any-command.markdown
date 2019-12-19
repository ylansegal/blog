---
layout: post
title: "Pipe Atom Text Into Any Command"
date: 2017-10-18 16:47:00 -0700
comments: true
categories:
- productivity
- atom
- unix
---

On my day-to-day software engineering tasks, I sometimes have the need to pass the file or selection through another program and replace it with the output. The uncomfortable workflow on my Mac is:

- Select text and copy (`command-c`)
- Open a terminal and type:

  ```
  $ pbpaste | some_command | pbcopy
  ```

- Go back to my editor and paste (`command-v`)

Lately, I've been doing that workflow more often. It was starting to become annoying. Vim and Emacs have long had support for manipulating the current buffer in this way. There is a package that does just that for [Atom][atom], my editor choice: The aptly-named [pipe][pipe].

> Select text to pipe into external commands and replace it with the output. Sort of like ! in vim. Commands are sent to your $SHELL.

## Examples

### Formatting SQL

Assuming I have a selection like:

```sql
SELECT
    `account_usr`.`account_uid`,
    GREATEST (`account`.`created_at`, IFNULL (`oauthorization`.`created_at`, 0),IFNULL (`usr`.`last_login`, 0)) AS last_used_at
FROM
    `account_usr` LEFT OUTER JOIN `account` ON `account_usr`.`account_uid` = `account`.`uid`
    LEFT OUTER JOIN `usr` ON `account_usr`.`user_uid` = `usr`.`uid`
    LEFT OUTER JOIN `oauthorization` ON `usr`.`uid` = `oauthorization`.`user_uid`
WHERE (`account`.`end_date` > '2017-10-25')
AND `account`.`product_uid` IN (1, 10)
GROUP BY `account`.`uid`
HAVING last_used_at < '2016-10-10 17:26:57.301147'
```

I can select it, run `pipe` (`command-;`) and type `pg_format` at the prompt. The selection now becomes:

```sql
SELECT
    `account_usr`.`account_uid`,
    GREATEST (`account`.`created_at`,
        IFNULL (`oauthorization`.`created_at`,
            0),
        IFNULL (`usr`.`last_login`,
            0)) AS last_used_at
FROM
    `account_usr`
    LEFT OUTER JOIN `account` ON `account_usr`.`account_uid` = `account`.`uid`
    LEFT OUTER JOIN `usr` ON `account_usr`.`user_uid` = `usr`.`uid`
    LEFT OUTER JOIN `oauthorization` ON `usr`.`uid` = `oauthorization`.`user_uid`
WHERE (`account`.`end_date` > '2017-10-25')
AND `account`.`product_uid` IN (1, 10)
GROUP BY
    `account`.`uid`
HAVING
    last_used_at < '2016-10-10 17:26:57.301147'
```

### Writing Ruby Documentation or Examples

When creating blog posts, pull request or other code examples, I often use the fantastic `xmpfilter` -- part of the `rcodetools` gem.

Starting selection:

```ruby
require "ostruct"

person = OpenStruct.new(name: "Ylan", last_name: "Segal")

person.name # =>
person.last_name # =>
```

After piping to `xmpfilter`

```ruby
require "ostruct"

person = OpenStruct.new(name: "Ylan", last_name: "Segal")

person.name # => "Ylan"
person.last_name # => "Segal"
```

## Conclusions

The `pipe` package opens up a world of possibility for working with your current buffer and all the CLI tools that already exist. Give it a try.

[atom]: https://atom.io/
[pipe]: https://atom.io/packages/pipe
