---
layout: post
title: "Postgres default values as a backfill method"
date: 2024-10-17 10:43:44 -0700
categories:
- postgres
excerpt_separator: <!-- more -->
---

Often, I want to add a new column to a Postgres table with a default value for new records, but also want existing records to have a *different* value. Changing Postgres default value can make this a very fast operation.

Let's see an example. Let's assume we have a `songs` table, and we want to add a `liked` column. Existing records need to have the value be set to `false`, while new values have it set to `true`.


Table and initial data setup:

```sql
CREATE TABLE songs (
  name character varying NOT NULL
);
-- CREATE TABLE
-- Time: 16.084 ms

INSERT INTO songs(name) VALUES ('Stairway To Heaven');
-- INSERT 0 1
-- Time: 0.590 ms

SELECT * FROM songs;
--         name
-- --------------------
--  Stairway To Heaven
-- (1 row)
--
-- Time: 0.652 ms
```

Now, let's add the new column with a default value of `false`. That is not our end-goal, but it will add that value to existing records[^1]:

```sql
ALTER TABLE songs
ADD COLUMN liked boolean DEFAULT false;
-- ALTER TABLE
-- Time: 3.745 ms

SELECT * FROM songs;
--         name        | liked
-- --------------------+-------
--  Stairway To Heaven | f
-- (1 row)
--
-- Time: 0.672 ms

ALTER TABLE songs
ALTER COLUMN liked SET NOT NULL;
-- ALTER TABLE
-- Time: 1.108 ms
```

Now, if we change the default value to `true`, and insert a new record:

```sql
ALTER TABLE songs ALTER COLUMN liked SET DEFAULT true;
-- ALTER TABLE
-- Time: 4.664 ms

INSERT INTO songs(name) VALUES ('Hotel California');
-- INSERT 0 1
-- Time: 1.447 ms

SELECT * FROM songs;
--
--         name        | liked
-- --------------------+-------
--  Stairway To Heaven | f
--  Hotel California   | t
-- (2 rows)
--
-- Time: 0.791 ms
```

As we can see, we have the schema in the shape that we want, and the correct data stored in it, without needing a "traditional" backfill to modify each existing row manually. The default value method is much faster, since Postgres doesn't need to update each record, just check the default value when they were created. 👍🏻

[^1]: *Stairway To Heaven* is excellent. I'm not implying that I don't like it. I do. It's an anthem.
