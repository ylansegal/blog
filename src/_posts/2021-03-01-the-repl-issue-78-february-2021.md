---
layout: post
title: "The REPL: Issue 78 - February 2021"
date: 2021-03-01T14:06:49-08:00
categories:
- the repl
excerpt_separator: <!-- more -->
---

### [Understanding SQL JOIN][sql_join]

Edward Loveall explains a useful frame of mind to understand `SQL JOIN` statements. The key to understanding them is to know that the `SQL` statement will act on **one** relation (called a table in the article). What `JOIN` statements do, is create a new relation from other relations (or tables). A [follow-up][group_by] explains `GROUP BY`.


### [A Data Pipeline is a Materialized View][view]

Nicholas Chammas makes the argument that a data pipeline is a form of a materialized view: A data structured derived from a primary source, and persisted. Thinking about primary vs. derived data resonates with me, and is one of the main take-aways from Designing [Designing Data-Intensive Applications]({% post_url 2019-07-10-book-review-designing-data-intensive-applications %}).

### [Do You Need an Event Bus? A Quick Overview of Five Common Uses][event_bus]

The thing that surprised me the most about this article by Lyric Hartley, is that in all 5 examples, the event bus (Kafka) is **always** fed from a database. It is always used as derived data, and never as a primary. While I think that is a lot of the real-life use cases out there, it leaves out the architectures, like event-driven, that use the even bus as a primary source.

[sql_join]: https://thoughtbot.com/blog/understanding-sql-join
[group_by]: https://thoughtbot.com/blog/understanding-sql-group-by
[view]: https://nchammas.com/writing/data-pipeline-materialized-view
[event_bus]: https://medium.com/salesforce-architects/do-you-need-an-event-bus-a-quick-overview-of-five-common-uses-722ae9b50765
