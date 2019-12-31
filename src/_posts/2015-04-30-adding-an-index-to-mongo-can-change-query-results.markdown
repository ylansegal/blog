---
layout: post
title: "Adding An Index To Mongo Can Change Query Results"
date: 2015-04-30 20:09:50 -0700
comments: true
categories:
- mongo
---

While trying to optimize some slow queries in a MongoDB database, I found an unexpected and concerning surprise: Adding an index can alter the results returned by a query against the same dataset.

Demonstration
=============

Supose we have a collection that looks like this (All samples from a mongo shell):

```
> db.example.find()
{
	"_id" : ObjectId("5542ef97b08a749f8e8e4f0d"),
	"title" : "Pink Floyd",
	"rating" : 1
}
{
	"_id" : ObjectId("5542efa2b08a749f8e8e4f0e"),
	"title" : "Led Zeppelin",
	"rating" : 2
}
{
	"_id" : ObjectId("5542efb3b08a749f8e8e4f0f"),
	"title" : "Aerosmith",
	"rating" : null
}
{
  "_id" : ObjectId("5542efbab08a749f8e8e4f10"),
  "title" : "Metallica"
}
```

Note that some documents have a numeric `rating`, one has a `null` value and one does not have the field.

Suppose we query for all documents with a rating of `1` or `null`:

```
> db.example.find({rating: { $in: [1, null]}})
{
	"_id" : ObjectId("5542ef97b08a749f8e8e4f0d"),
	"title" : "Pink Floyd",
	"rating" : 1
}
{
	"_id" : ObjectId("5542efb3b08a749f8e8e4f0f"),
	"title" : "Aerosmith",
	"rating" : null
}
{
  "_id" : ObjectId("5542efbab08a749f8e8e4f10"),
  "title" : "Metallica"
}
```

The `Metallica` document is returned, even though it does not have a `rating` field.

Suppose that we want to optimize this collection and now we add an index on the rating field and re-run our query:

```
> db.example.ensureIndex({rating: 1}, {sparse: true})
{
	"createdCollectionAutomatically" : false,
	"numIndexesBefore" : 1,
	"numIndexesAfter" : 2,
	"ok" : 1
}
> db.example.find({rating: { $in: [1, null]}})
{
	"_id" : ObjectId("5542efb3b08a749f8e8e4f0f"),
	"title" : "Aerosmith",
	"rating" : null
}
{
	"_id" : ObjectId("5542ef97b08a749f8e8e4f0d"),
	"title" : "Pink Floyd",
	"rating" : 1
}
```

The `Metallica` document is gone. Surprised? I definetly was.

Thoughts
========

The behavior may seem a bit contrived, but I actually encountered it while trying to optimize a produciton database. This example just boils it down to something trivial to reproduce. I should mention that if the index is created without the `sparse` option, the results are correct. The `sparse` option allows saving space on the index itself, by only creating an entry for documents that have the field. A non-sparse index, creates a record for all documents and sets the value to `null`.

In my opinion, the above-described behavior is awful. It is up to the database engine to decide which index to use. A sparse index may be useful in less queries than a non-sparse index. However, my expectations of indexes is that they are all about performance and trading off disk space and insert time for query time. The existance of an index should never change the result set for the same query and dataset.
