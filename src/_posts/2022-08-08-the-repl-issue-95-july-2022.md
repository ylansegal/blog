---
layout: post
title: "The REPL: Issue 94 - June 2022"
date: 2022-08-08 10:36:50 -0700
categories:
- the repl
excerpt_separator: <!-- more -->
---

### [The Bullshit Web][1]

Nick Heer laments the state of the current web. Modem speed in the 1990s were 56K modem (I started connecting with the internet on a 14.4K connection). Connection speeds are orders of magnitude faster, and yet web pages still feel slow. It's the bloat. The embedded videos you don't watch, the trackers, the ads. It's all bullshit.

### [Failed #SquadGoals][2]

Jeremiah Lee writes about the famed Spotify model. It was copied and talked about widely. It turns out, not even Spotify used that model. At least not to the extent that was implied in the [original whitepaper](https://blog.crisp.se/wp-content/uploads/2012/11/SpotifyScaling.pdf). Remember that what you read companies are doing in their blog posts and whitepapers might not be _exactly_ what they are doing, and when they move on to something else, they rarely go back to talk about the mistakes that they made in the first place.

### [Soft Deletion Probably Isn't Worth It][3]

Brandur contends that soft-deletion is usually not worth it. It's rarely used, complicates the model, and on top of that breaks foreign keys. I agree with all that. Especially loosing foreign keys. As an alternative, he proposes using a generic `deleted_records` table, storing most of the columns in JSON, and populating on deletion. It preserves foreign keys, and preserves the audit ability for customer support. He doesn't mention it, but it strikes me that it can easily be partitioned for scalability.

There is another alternative I've written about: [Temporal Modeling](/categories/bi-temporal-data/). The issue with temporal modeling, is that it also looses foreign key constraints as they are implemented in typical relational databases. The database can still enforce via constraints on date ranges, but it requires a lot more work. I wish there was a Postgres extension that was temporal modeling aware and simplified constraint generation.


[1]: https://pxlnv.com/blog/bullshit-web/
[2]: https://www.jeremiahlee.com/posts/failed-squad-goals/
[3]: https://brandur.org/soft-deletion
