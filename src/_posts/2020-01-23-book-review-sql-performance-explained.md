---
layout: post
title: "Book Review: SQL Performance Explained"
date: Thu Jan 23 15:35:26 PST 2020
comments: true
categories:
- books
- databases
---

Relational database management systems are battle-tested technology that continues to be the go-to technology for a broad spectrum of applications. While not strictly necessary, the interface the most common RDBMS is through writing SQL. In this book, Markus Winand writes a thorough guide to understanding the performance of SQL databases.

> It turns out that the only thing developers need to learn is how to index. Database indexing is, in fact, a development task.

The text introduces the underlying data structures that make databases work, with the aims of increasing the readers comprehension. In particular, balance-tree indexes take front and center stage, due to their importance in creating indexes. The author builds on this knowledge to explain, with detailed examples, the different type of `WHERE` clauses and what type of indexes can be created to improve performance when querying.

Most of the examples are for the Oracle family of products, with plenty of information along the way on how `MySQL`, `Postrgres`, and `MS SQL Server` differ from it. I don't have _any_ experience with Oracle, but found the examples clear and the concepts transfer well to other systems. In fact, I found the explanations on differences in internal implementations of particular interest, since they sometimes affect how a developer optimizes queries.

### Links:
- [SQL Performance Explained](https://sql-performance-explained.com/)
- [Markus Winand](https://winand.at/)
