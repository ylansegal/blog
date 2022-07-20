---
layout: post
title: "Postgres Ranges"
date: 2020-05-07 15:27:42 -0700
categories:
- databases
- postgres
- bi temporal data
excerpt_separator: <!-- more -->
---

In my previous posts about [bi-temporal data](/categories/bi-temporal-data/), I dealt with a lot of queries that had where clauses that dealt with operations in dates. For example:

```sql
SELECT
    employee_id,
    committee_id
FROM
    committee_membership
WHERE
    valid_from <= '2020-05-02'
    AND '2020-05-02' < valid_up_to
    AND tx_applicable_from <= NOW()
    AND NOW() < tx_applicable_up_to
```

The underlying schema looks like this:

```sql
CREATE table committee_membership (
  employee_id int NOT NULL,
  committee_id int NOT NULL,
  valid_from date NOT NULL,
  valid_up_to date NOT NULL,
  tx_applicable_from date NOT NULL,
  tx_applicable_up_to date NOT NULL
)
```

The four dates in the table share the same structure. There are two prefixes `valid` and `tx_applicable`, and two suffixes `from` and `up_to`. This structure that hints that the dates represent two different concepts: An interval in time that delineates validity and an interval that delineates applicability.

<!-- more -->

Postgres has a support built-in for [Ranges][ranges] that make it easier to deal with them. From the manual:

> Range types are data types representing a range of values of some element type (called the range's subtype).

> Range types are useful because they represent many element values in a single range value, and because concepts such as overlapping ranges can be expressed clearly.

The data from the [previous post]({% post_url 2020-04-24-modeling-bitemporal-deletions %}) can be re-designed to use ranges:

```sql
CREATE table committee_membership (
  employee_id int NOT NULL,
  committee_id int NOT NULL,
  valid daterange NOT NULL,
  applicable daterange NOT NULL
)
```

When dealing with ranges, it is important to think about the bounds of the range. They can be either inclusive or exclusive:

> Every non-empty range has two bounds, the lower bound and the upper bound. All points between these values are included in the range. An inclusive bound means that the boundary point itself is included in the range as well, while an exclusive bound means that the boundary point is not included in the range.

> In the text form of a range, an inclusive lower bound is represented by “[” while an exclusive lower bound is represented by “(”. Likewise, an inclusive upper bound is represented by “]”, while an exclusive upper bound is represented by “)”.

The naming convention we used before we used the suffix `_from` that indicated inclusivity in the lower bound. The suffix `up_to` indicated exclusivity on upper bound[^1]. This means that the textual form will be `[)`. This is also known as an open-closed range. This type of range has the advantage that the same value can be used for the upper bound of one record and the lower bound of another and the result are two ranges that are adjacent two each other without overlap (one starts where the other ends, with no gap).

# Querying

Let's add some example data, and re-write the queries from the previous post.


```sql
INSERT INTO committee_membership
VALUES
  (1, 500, daterange('2018-01-01', '2020-05-01', '[)'), daterange('2018-01-01', null, '[)')),
  (2, 500, daterange('2018-01-01', null, '[)'), daterange('2018-01-01', null, '[)')),
  (1, 500, daterange('2020-05-01', '2020-05-01', '[)'), daterange('2020-04-24', null, '[)')),
  (1, 600, daterange('2019-01-01', null, '[)'), daterange('2019-01-01', null, '[)'))

SELECT * from committee_membership;
-- employee_id | committee_id |          valid          |  applicable
-- -------------+--------------+-------------------------+---------------
--           1 |          500 | [2018-01-01,2020-05-01) | [2018-01-01,)
--           2 |          500 | [2018-01-01,)           | [2018-01-01,)
--           1 |          500 | empty                   | [2020-04-24,)
--           1 |          600 | [2019-01-01,)           | [2019-01-01,)
-- (4 rows)
```

The `null` values in the upper bounds is Postgres way of specifying infinite our unbounded ranges. Note also that Postgres detects when ranges can't contain any members, and displays them as `empty`.

The data above, represent bi-temporal data. Here are some example queries, using the `@>` operator, described in the [documentation][operators] as `contains element`. We will use it to limit queries that fall with in a certain range.

```sql
-- What is the committee membership as of 2020-04-25?
SELECT
    employee_id,
    committee_id
FROM
    committee_membership
WHERE
    valid @> '2020-04-25'::date
    AND applicable @> NOW()::date
--  employee_id | committee_id
-- -------------+--------------
--            1 |          500
--            2 |          500
--            1 |          600
-- (3 rows)
--
-- Time: 0.996 ms

-- What is the committee membership now?
SELECT
    employee_id,
    committee_id
FROM
    committee_membership
WHERE
    valid @> NOW()::date
    AND applicable @> NOW()::date
--  employee_id | committee_id
-- -------------+--------------
--            2 |          500
--            1 |          600
-- (2 rows)
--
-- Time: 0.946 ms

-- What was the committee membership on 2018-01-01?
SELECT
    employee_id,
    committee_id
FROM
    committee_membership
WHERE
    valid @> '2018-01-01'::date
    AND applicable @> '2018-01-01'::date
--  employee_id | committee_id
-- -------------+--------------
--            1 |          500
--            2 |          500
-- (2 rows)
--
-- Time: 0.857 ms
```

# Indexing & Constraints

Postgres also supports `GiST` and `SP-GiST` indexes on range fields, which makes operations on them more efficient:

```sql
CREATE INDEX range_idx ON committee_membership USING GIST  (valid, applicable);
```

Indexing also allows the addition of constraints to the tables that would otherwise be hard to express. For example, we can add a constraint that excludes the same employee belonging to the same committee on overlapping ranges.

```sql

CREATE EXTENSION IF NOT EXISTS btree_gist;

ALTER TABLE committee_membership
    ADD EXCLUDE USING GIST (employee_id WITH =, committee_id WITH =, valid WITH &&);

-- The constraint prevents the following record from being inserted
INSERT INTO committee_membership
VALUES
  (1, 500, daterange('2019-01-01', '2022-08-26', '[)'), daterange('2019-01-01', null, '[)'));
-- ERROR:  conflicting key value violates exclusion constraint "committee_membership_employee_id_committee_id_valid_excl"
-- DETAIL:  Key (employee_id, committee_id, valid)=(1, 500, [2019-01-01,2022-08-26)) conflicts with existing key (employee_id, committee_id, valid)=(1, 500, [2018-01-01,2020-05-01)).
```

# Takeaway

Postgres ranges can simplify certain domain modeling. They support common data subtypes, and can be extended if needed. Range types can be indexed, which allows for performance tuning, and use in constraints.

[^1]: Had it been inclusive, I would have used `_thru` for the upper bound.

[ranges]: https://www.postgresql.org/docs/12/rangetypes.html
[operators]: http://www.postgresql.org/docs/12/interactive/functions-range.html
