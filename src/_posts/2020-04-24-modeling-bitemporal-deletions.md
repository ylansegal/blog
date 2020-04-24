---
layout: post
title: "Modeling Bi-Temporal Deletions"
date: 2020-04-24 11:03:24 -0700
categories:
- databases
- bi temporal data
excerpt: |
  In non-temporal data, deletions are literal: Specific rows or columns are deleted, because only the current state is modeled. In bi-temporal data, the equivalent operation is modeled by inserting new facts.
---

In a [previous post]({% post_url 2020-04-18-til-bitemporal-data %}) I discussed the richness that bi-temporality can bring to our data. I covered how to deal with data updates. Let's discuss deletions.

In non-temporal data, deletions are literal: Specific rows or columns are deleted, because only the current state is modeled. As an example, lets assume that we are modeling an HR application that tracks which employees belong to internal committees. A non-temporal join table looks like this:

| employee_id | committee_id |
|:-----------:|:------------:|
|      1      |     500      |
|      2      |     500      |
|      1      |     600      |

Deletions then are simple SQL statements that remove a row. Non-temporal tables have any capacity to query facts about the past, only the present. Let's convert to a bi-temporal table:

| employee_id | committee_id | valid_from | valid_up_to | tx_applicable_from | tx_applicable_up_to |
|:-----------:|:------------:|:----------:|:-----------:|:------------------:|:-------------------:|
|      1      |     500      | 2018-01-01 | 9999-12-31  |     2018-01-01     |     9999-12-31      |
|      2      |     500      | 2018-01-01 | 9999-12-31  |     2018-01-01     |     9999-12-31      |
|      1      |     600      | 2019-01-01 | 9999-12-31  |     2019-01-01     |     9999-12-31      |


`9999-12-31` is a stand-in for "forever". Our current state is equivalent to our previous table, but we maintain the ability to query about past history. In SQL:

```sql
CREATE table committee_membership (
  employee_id int NOT NULL,
  committee_id int NOT NULL,
  valid_from date NOT NULL,
  valid_up_to date NOT NULL,
  tx_applicable_from date NOT NULL,
  tx_applicable_up_to date NOT NULL
)

INSERT INTO committee_membership
  VALUES
  (1, 500, '2018-01-01', '9999-12-31', '2018-01-01', '9999-12-31'),
  (2, 500, '2018-01-01', '9999-12-31', '2018-01-01', '9999-12-31'),
  (1, 600, '2019-01-01', '9999-12-31', '2019-01-01', '9999-12-31')

SELECT
    employee_id,
    committee_id
FROM
    committee_membership
WHERE
    valid_from <= NOW()
    AND NOW() < valid_up_to
    AND tx_applicable_from <= NOW()
    AND NOW() < tx_applicable_up_to
--  employee_id | committee_id
-- -------------+--------------
--            1 |          500
--            2 |          500
--            1 |          600
-- (3 rows)
--
-- Time: 7.243 ms

```

Our main objective is to preserve a rich history in our model, which precludes us from deleting any data. In fact, we are only allowed to insert new facts into our tables. They only modify previous facts in that new facts may make previous facts no longer valid or no longer applicable.

Our current facts in the table deal only with current modifications: Those that are valid from the moment of insertion until "forever". In the [previous post]({% post_url 2020-04-18-til-bitemporal-data %}) we also saw that we can use sequenced modifications: Those that are valid for a specific period in time (past, present, or future). A deletion can then be modeled as an insertion of a fact that sets the `valid_up_to` date to a known value.

For example, let us supposed that on `2020-04-24` employee 1 resigns -- effective `2020-05-01` -- from committee 500.

```sql
BEGIN;

INSERT INTO committee_membership
    VALUES (1, 500, '2020-05-01', '2020-05-01', '2020-04-24', '9999-12-31');

UPDATE
    committee_membership
SET
    valid_up_to = '2020-05-01'
WHERE
    employee_id = 1
    AND committee_id = 500;

COMMIT;

SELECT * FROM committee_membership;
--  employee_id | committee_id | valid_from | valid_up_to | tx_applicable_from | tx_applicable_up_to
-- -------------+--------------+------------+-------------+--------------------+---------------------
--            2 |          500 | 2018-01-01 | 9999-12-31  | 2018-01-01         | 9999-12-31
--            1 |          600 | 2019-01-01 | 9999-12-31  | 2019-01-01         | 9999-12-31
--            1 |          500 | 2018-01-01 | 2020-05-01  | 2018-01-01         | 9999-12-31
--            1 |          500 | 2020-05-01 | 2020-05-01  | 2020-04-24         | 9999-12-31
-- (4 rows)
--
-- Time: 0.647 ms
```

Our newly inserted facts states sets both the `valid_from` and `valid_up_to` to the effective resignation date. After that, there is no longer a record with a valid range that links employee 1 to committee 500. Effectively, this "deletes" the record. The `tx_applicable_from` for our new fact is always set to the system time. It represent **when** we learned about that fact.

The `UPDATE` statement is necessary to propagate our new knowledge: While before our best knowledge was the the employee would belong to the committee "forever", now we know that that will only be true until `2020-05-01`.

In this case our transaction-time timestamps do not need to be adjusted: As far as we know, each fact recorded still reflects our best knowledge at the time. For certain bi-temporal modifications, such as corrections of past facts, the `tx_applicable_up_to` for previous facts does need to be adjusted. Refer to [Snodgrass][snodgrass] for a full discussion.

With our new fact in place we can query for membership at different times:

```sql
--- What is the committee membership as of 2020-04-25, to the best of our knowledge
--- On this date we already "know" about the resignation, but it's not yet a valid fact.
SELECT
    employee_id,
    committee_id
FROM
    committee_membership
WHERE
    valid_from <= '2020-04-25'
    AND '2020-04-25' < valid_up_to
    AND tx_applicable_from <= NOW()
    AND NOW() < tx_applicable_up_to
--  employee_id | committee_id
-- -------------+--------------
--            2 |          500
--            1 |          600
--            1 |          500
-- (3 rows)
--
-- Time: 3.426 ms


--- What is the committee membership as of 2020-05-02, to the best of our knowledge
--- On this date the resignation is valid.
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
--  employee_id | committee_id
-- -------------+--------------
--            2 |          500
--            1 |          600
-- (2 rows)
--
-- Time: 0.942 ms
```

Note that the "deletion" is reflected in the last query.

# Conclusion

Non-temporal deletions are modeled in bi-temporal data with insertions, preserving the full history, auditing capabilities and richness associated with bi-temporal data.

[snodgrass]: http://www2.cs.arizona.edu/people/rts/tdbbook.pdf
