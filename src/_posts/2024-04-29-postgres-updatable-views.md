---
layout: post
title: "Postgres Updatable Views"
date: 2024-04-29 17:44:53 -0700
categories:
- postgres
excerpt_separator: <!-- more -->
---

Postgres has support for creating views that are themselves updatable, as if they are tables. By default, this is only possible for simple views, as [defined in the documentation](https://www.postgresql.org/docs/12/sql-createview.html). More advanced views, *can* also be updatable, with a bit more work. Lets examine how.

For the sake of this example[^1], lets say we have a `user_last_logins` table that captures the last date and time that the user has logged into a system:

```sql
CREATE TABLE user_last_logins (
  user_id integer NOT NULL,
  logged_in_at timestamp NOT NULL
);
-- CREATE TABLE
-- Time: 10.102 ms

CREATE UNIQUE INDEX idex_user_id_on_user_last_logins
ON user_last_logins(user_id);
-- CREATE INDEX
-- Time: 7.783 ms
```

Somewhere in the application code, when the user logs in, we update the time that a user has logged in.

```sql
INSERT INTO user_last_logins(user_id, logged_in_at)
VALUES
  (1, NOW()), (2, NOW()), (3, NOW());
-- INSERT 0 3
-- Time: 5.007 ms

SELECT * FROM user_last_logins;
--  user_id |        logged_in_at
-- ---------+----------------------------
--        1 | 2024-04-29 14:36:11.765157
--        2 | 2024-04-29 14:36:11.765157
--        3 | 2024-04-29 14:36:11.765157
-- (3 rows)
--
-- Time: 0.481 ms


UPDATE user_last_logins
SET logged_in_at = NOW()
WHERE user_id = 1;
-- UPDATE 1
-- Time: 5.463 ms

SELECT * FROM user_last_logins;
--  user_id |        logged_in_at
-- ---------+----------------------------
--        2 | 2024-04-29 14:36:11.765157
--        3 | 2024-04-29 14:36:11.765157
--        1 | 2024-04-29 14:36:22.268137
-- (3 rows)
--
-- Time: 0.973 ms

```

Notice how the timestamp for the row with `user_id = 1` was updated.

Now lets imagine that our requirements change. We are now set to record the time of **every** login by users, as opposed to the last time. We also have different client applications that might not be on the same schedule, and would like to keep the current database functionality intact. Our first order of business is to create our new table and populated with the information we have at hand:

```sql
BEGIN;

CREATE TABLE user_logins (
  user_id integer NOT NULL,
  logged_in_at timestamp NOT NULL
);

INSERT INTO user_logins (user_id, logged_in_at)
SELECT * FROM user_last_logins;

COMMIT;
-- BEGIN
-- Time: 0.129 ms
-- CREATE TABLE
-- Time: 4.720 ms
-- INSERT 0 3
-- Time: 0.842 ms
-- COMMIT
-- Time: 0.339 ms

SELECT * from user_logins;
--
--  user_id |        logged_in_at
-- ---------+----------------------------
--        2 | 2024-04-29 14:36:11.765157
--        3 | 2024-04-29 14:36:11.765157
--        1 | 2024-04-29 14:36:22.268137
-- (3 rows)
--
-- Time: 0.816 ms

```

The new table has the same structure as the old table, but has no unique index on `user_id`, because we want to allow multiple rows for each user. I am aware that I could have renamed the table instead of creating a new one and copying data. I choose to do it this way for didactical purposes.

It's now possible to insert new records for each users:

```sql
INSERT INTO user_logins VALUES (1, NOW());
-- INSERT 0 1
-- Time: 1.613 ms

SELECT * from user_logins;
--  user_id |        logged_in_at
-- ---------+----------------------------
--        2 | 2024-04-29 14:36:11.765157
--        3 | 2024-04-29 14:36:11.765157
--        1 | 2024-04-29 14:36:22.268137
--        1 | 2024-04-29 14:37:23.696786
-- (4 rows)
--
-- Time: 0.505 ms
```

We still have a problem: There are clients to this application that can't change their code right away. Let's tackle first the clients that want to read an up-to-date `user_last_logins` relation:

```sql
BEGIN;

DROP TABLE user_last_logins;

CREATE OR REPLACE VIEW user_last_logins AS
SELECT user_id, MAX(logged_in_at) as logged_in_at
FROM user_logins
GROUP BY 1;

COMMIT;
-- BEGIN
-- Time: 0.103 ms
-- DROP TABLE
-- Time: 3.219 ms
-- CREATE VIEW
-- Time: 6.703 ms
-- COMMIT
-- Time: 1.338 ms

SELECT * FROM user_last_logins;
--  user_id |        logged_in_at
-- ---------+----------------------------
--        3 | 2024-04-29 14:36:11.765157
--        2 | 2024-04-29 14:36:11.765157
--        1 | 2024-04-29 14:37:23.696786
-- (3 rows)
--
-- Time: 1.273 ms

```

We've created a view that produced the same information that used to be in `user_last_logins` from the underlying `user_logins` table, with the same guarantees that a `user_id` will only show up in a single row. Read clients can continue working without a hitch. However, write clients won't be able to update as before:

```sql
UPDATE user_last_logins
SET logged_in_at = NOW()
WHERE user_id = 1;
-- ERROR:  cannot update view "user_last_logins"
-- DETAIL:  Views containing GROUP BY are not automatically updatable.
-- HINT:  To enable updating the view, provide an INSTEAD OF UPDATE trigger or an unconditional ON UPDATE DO INSTEAD rule.
-- Time: 0.975 ms
```

Conceptually, we know that the underlying table has the same structure, and that the insert to the view can be forwarded to the underlying table. The error even gives us a hint at what to do: Use and `INSTEAD OF UPDATE` trigger.

```sql
BEGIN;

CREATE OR REPLACE FUNCTION instead_function_insert_user_last_logins() RETURNS TRIGGER AS
$BODY$
BEGIN

INSERT INTO user_logins(user_id, logged_in_at)
VALUES (NEW.user_id, NEW.logged_in_at);

RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER instead_trigger_user_last_logins
INSTEAD OF UPDATE ON user_last_logins
FOR EACH ROW
EXECUTE PROCEDURE instead_function_insert_user_last_logins();

COMMIT;
-- BEGIN
-- Time: 0.077 ms
-- CREATE FUNCTION
-- Time: 6.508 ms
-- CREATE TRIGGER
-- Time: 2.049 ms
-- COMMIT
-- Time: 0.427 ms
```

We've defined a trigger that runs on each attempted update of `user_last_logins` and **instead** runs a function. The body of the function plainly inserts instead into `user_logins`. And because `user_logins` powers the `user_last_logins` view, the insert appears to work as requested.

```sql
UPDATE user_last_logins
SET logged_in_at = NOW()
WHERE user_id = 1;
-- UPDATE 1
-- Time: 6.153 ms

SELECT * FROM user_last_logins;
--  user_id |        logged_in_at
-- ---------+----------------------------
--        3 | 2024-04-29 14:36:11.765157
--        2 | 2024-04-29 14:36:11.765157
--        1 | 2024-04-29 14:38:39.369368
-- (3 rows)
--
-- Time: 0.696 ms


SELECT * FROM user_logins;
--  user_id |        logged_in_at
-- ---------+----------------------------
--        2 | 2024-04-29 14:36:11.765157
--        3 | 2024-04-29 14:36:11.765157
--        1 | 2024-04-29 14:36:22.268137
--        1 | 2024-04-29 14:37:23.696786
--        1 | 2024-04-29 14:38:39.369368
-- (5 rows)
--
-- Time: 0.826 ms
```

Now our existing clients can migrate to use `user_logins` at their own pace. For this particular case, we only dealt with `INSTEAD OF UPDATE`, but in the same vein we could have defined an `INSTEAD OF INSERT` trigger.

## Conclusions

The `INSTEAD OF` trigger allows us a complex view to remain updatable. In this made-up-case this allows views to function as an abstraction for tables that no longer exist, and de-couples the need from client code changing at the same time as the database schema.

[^1]: I used Postgres v12.5 for this example.
