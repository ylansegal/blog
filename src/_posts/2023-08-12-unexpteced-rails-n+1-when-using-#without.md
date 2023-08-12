---
layout: post
title: "Unexpteced Rails N+1 when using #without"
date: 2023-08-12 12:46:32 -0700
categories:
- rails
excerpt_separator: <!-- more -->
---

I recently noticed an unexpected N+1 in a Rails project when using [#without](https://api.rubyonrails.org/v7.0.0/classes/ActiveRecord/QueryMethods.html#method-i-excluding) (aliased from `#excluding`).

The feature is a page that lists all available programs, and a list of participants *other* than the current user. In its basic form it's equivalent to:

```ruby
# Controller:
programs = Program.all.includes(:participants)
# Program Load (2.0ms)  SELECT "programs".* FROM "programs"
# ProgramParticipant Load (1.0ms)  SELECT "program_participants".* FROM "program_participants" WHERE "program_participants"."program_id" IN ($1, $2)  [["program_id", 1], ["program_id", 2]]
# Person Load (0.5ms)  SELECT "people".* FROM "people" WHERE "people"."id" IN ($1, $2, $3)  [["id", 4], ["id", 2], ["id", 3]]

# View
programs.map do |program|
  program.participants.without(current_user).map { _1.first_name }.join(", ")
end
# Person Load (1.5ms)  SELECT "people".* FROM "people" INNER JOIN "program_participants" ON "people"."id" = "program_participants"."participant_id" WHERE "program_participants"."program_id" = $1 AND "people"."id" != $2  [["program_id", 1], ["id", 4]]
# Person Load (0.6ms)  SELECT "people".* FROM "people" INNER JOIN "program_participants" ON "people"."id" = "program_participants"."participant_id" WHERE "program_participants"."program_id" = $1 AND "people"."id" != $2  [["program_id", 2], ["id", 4]]
# => ["Gabriel", "Gabriel, Alex"]
```

Notice that participant (in `people` table) are being loaded, and seemingly ignoring the `includes` in the controller.

The N+1 was **not** present before this app was upgraded to Rails 7.0. That is key. We can see in the [changelog](https://github.com/rails/rails/blob/7-0-stable/activerecord/CHANGELOG.md) the implementation of `ActiveRecord::Relation#excluding` (but not mentioned in the guide as a [notable change](https://guides.rubyonrails.org/7_0_release_notes.html#active-record-notable-changes)). Before that, `excluding` (or `without`) was implemented in `Enumerable`, which didn't create the N+1. In fact, using that method -- by calling `to_a` on the relation -- returns us to the desired behavior:

```ruby
programs.map do |program|
  program.participants.to_a.without(current_user).map { _1.first_name }.join(", ")
end
# => ["Gabriel", "Alex, Gabriel"]
# --> Same result, no extra query!
```

## Conclusion

Typically, doing more work in the database and less in Ruby brings performance improvements. In this specific case, the optimization prevented using already loaded data, which resulted in many more queries and overall worse performance. Catching these errors when upgrading Rails is difficult, because the functionality was actually not affected.
