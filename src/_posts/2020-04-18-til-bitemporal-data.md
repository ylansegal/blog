---
layout: post
title: "Bi-Temporal Data"
date: 2020-04-18 13:20:18 -0700
categories:
- databases
- bi temporal data
excerpt_separator: <!-- more -->
---

Bi-temporal data refers to a modeling technique to store and retrieve data that changes on two different axes. The valid time axis refers to the range of time in which data is valid. Transaction time refers to when the system recorded the data. Keeping track of both with expose a very rich data model.

In the simplest data modeling, a system keeps track of the current state. Let's assume that we are working with a system that keeps track of company personnel. In its `people` table, it will hold things like first and last names, date of birth, and social security numbers. At first sight, this seem like invariant facts, but upon closer inspection we can see that in reality they are not. People often change their name when their marital status changes, and birth date and social security number are technically facts that don't change, but often need to be corrected. These two very different reasons for change are often conflated, or worse, not accounted for. Bi-temporal data provides a way to deal with both.

<!-- more -->

The nomenclature for valid and transaction time varies in the literature. I am sticking to using valid and transaction time in this post.

Let's consider first properties that are valid for limited time ranges, and in particular the last name of a person. As an example, let's assume we hire an employee `Alice Asher` on 2010-01-01. Some time later (in 2012-01-01), they marry and change their name to `Alice Babson`. At an even later time (in 2015-01-01), Alice decides to hyphenate and use `Asher-Babson`.

We can model this facts like so:

| id | first_name |  last_name   | valid_from | valid_up_to |
|:--:|:----------:|:------------:|:----------:|:-----------:|
| 1  |   Alice    |    Asher     | 2010-01-01 | 2012-01-01  |
| 1  |   Alice    |    Babson    | 2012-01-01 | 2015-01-01  |
| 1  |   Alice    | Asher-Babson | 2015-01-01 | 9999-12-31  |


The above table presents a picture of data changing its validity in time. As (I hope) the names imply, the dates are inclusive in the lower range, but exclusive on the upper range. That is, on 2012-01-01 Alice's last name is `Babson`. Since our last known fact is that Alice's last name is `Asher-Babson`, our upper bound of validity is 9999-12-31, which I use as a placeholder *the end of time*: A range with an upper bound of 9999-12-31 means it is valid forever. I am using day granularity for brevity, but there is nothing preventing us from using timestamps.

The above modeling lets us ask what is Alice's full name at the moment, or what it was at any point in time. In SQL, we can write:

```sql
-- Current state
SELECT
    *
FROM
    people
WHERE
    id = 1
    AND valid_from <= NOW()
    AND NOW < valid_up_to
-- Alice Asher-Babson

-- Alice's name in the past
SELECT
    *
FROM
    people
WHERE
    id = 1
    AND valid_from <= '2013-04-15'
    AND '2013-04-15' < valid_up_to
-- Alice Babson
```

Now, let's consider another fact table: `salaries`. In it, we will record the current monthly salary of our employees. In this particular domain, it is even clearer that facts are only valid for a range of time. Employees have salary changes often, and it is clearly important to maintain the historical record.

| id | salary | valid_from | valid_up_to |
|:--:|:------:|:----------:|:-----------:|
| 1  | $2,000 | 2010-01-01 | 2011-01-01  |
| 1  | $2,200 | 2011-01-01 | 2012-01-01  |
| 1  | $2,500 | 2012-01-01 | 9999-12-31  |

In our example, we show a history of yearly salary increases. Now let us suppose that after the fact, we realize that because of a clerical error, Alice's salary for 2011 should have been $2,250 instead of the recorded $2,200. We'd like to correct the record and pay Alice the money that is missing, so we update the row to reflect a new knowledge. Next month, our auditor calls us: He just ran the payroll reports for 2011 and compared to the checks that were actually issued and found that they don't match. There is nothing in the database that explains the discrepancy.

The problem we are facing is one that is common -- but not exclusive -- to finance. There is a need to be able to run reports for data in the past *as it was back then*. For example, we might now know that the GDP in 2017-02 rose 0.5% month-to-month, but back in 2017-03 when it was first published it was thought to be 0.35%. Revisions are issued all the time. How can we model that?

Back in our salary example, we can start keeping track of our other axis of time: Transaction time. I find it helpful to think about this as marking the time that our system learned a new fact. The fact themselves can be about the past, present or future, but the lower bound of the transaction time is always increasing (as is the passage of time). Our original table, with transaction time, now looks like:

| id | salary | valid_from | valid_up_to | tx_applicable_from | tx_applicable_to |
|:--:|:------:|:----------:|:-----------:|:------------------:|:----------------:|
| 1  | $2,000 | 2010-01-01 | 2011-01-01  |     2010-01-15     |    9999-12-31    |
| 1  | $2,200 | 2011-01-01 | 2012-01-01  |     2011-01-15     |    9999-12-31    |
| 1  | $2,500 | 2012-01-01 | 2013-01-01  |     2012-01-15     |    9999-12-31    |

The extra data tells us that we learned of the new salaries two weeks after they became effective, and to the best of our knowledge, those facts are still true -- as noted by the upper bound being 9999-12-31. Now, we have a framework for adding a correction for past data.

| id | salary | valid_from | valid_up_to | tx_applicable_from | tx_applicable_to |
|:--:|:------:|:----------:|:-----------:|:------------------:|:----------------:|
| 1  | $2,000 | 2010-01-01 | 2011-01-01  |     2010-01-15     |    9999-12-31    |
| 1  | $2,200 | 2011-01-01 | 2012-01-01  |     2011-01-15     |    2013-01-15    |
| 1  | $2,500 | 2012-01-01 | 2013-01-01  |     2012-01-15     |    9999-12-31    |
| 1  | $2,250 | 2011-01-01 | 2012-01-01  |     2013-01-15     |    9999-12-31    |

Our new fact is recorded on 2013-01-15. It records the corrected salary for 2011, which is what we now think to be true. We also set the end of applicability of the last known salary for that period, since we now now that to be false. We now have achieved bi-temporality. Our auditor can run a report for 2011 payroll, *as it looked at the time*, and compare it to a report for the same period *as we now know if should have been*.

Querying now requires variance in both axes:

```sql
-- What is Alice's salary now?
SELECT
    *
FROM
    salaries
WHERE
    id = 1
    AND valid_from <= NOW()
    AND NOW() < valid_up_to
    AND tx_applicable_from <= NOW()
    AND NOW() < tx_applicable_to
-- $2,500

-- What was Alice's salary in 2011, as we know it now?
SELECT
    *
FROM
    salaries
WHERE
    id = 1
    AND valid_from <= '2011-06-15'
    AND '2011-06-15' < valid_up_to
    AND tx_applicable_from <= NOW()
    AND NOW() < tx_applicable_to
-- $2,250

-- What was Alice's salary in 2011, as we knew it then?
SELECT
    *
FROM
    salaries
WHERE
    id = 1
    AND valid_from <= '2011-06-15'
    AND '2011-06-15' < valid_up_to
    AND tx_applicable_from <= '2011-06-15'
    AND '2011-06-15' < tx_applicable_to
-- $2,200
```

Bi-temporal storage provides a powerful modeling technique that lets us model data that naturally varies in time, while also keeping track of when we learn of new facts. There is plenty more information to dig into in the following references:

- [The Case for Bitemporal Data](https://www.youtube.com/watch?v=PuocT5wUgJ4) (First of a seven part series)
- [Bi-temporal data modeling with Envelope](https://blog.cloudera.com/bi-temporal-data-modeling-with-envelope/)
- [Developing Time-Oriented Database Applications in SQL](http://www2.cs.arizona.edu/people/rts/tdbbook.pdf)
