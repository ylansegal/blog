---
layout: post
title: "Abstractions With Database Views"
# date: 2020-01-14 16:26:07 -0800
categories:
- rails
- databases
excerpt_separator: <!-- more -->
---

Wikipedia defines a [software abstraction][1] as:

> In software engineering and computer science, abstraction is...
the process of removing physical, spatial, or temporal details or attributes in the study of objects or systems to focus attention on details of greater importance; it is similar in nature to the process of generalization;

A database view can provide a useful abstraction; a concept that represents something in a domain. Recently, I had the opportunity to do use a view to create an abstraction, to represent data that is *missing* from the database.

<!-- more -->
---

I'm working on a system that tracks program participation for a community center. The relevant characteristic here are:
- Each program can have many participant.
- Programs can also have signature requirements: They are digital agreement that participants "sign". They can't participate in the program without them.
- It's important for the community center staff to track the signatures, and which participants have not fulfilled the requirements. Several programs can share the same signature requirement (e.g. a code of conduct).
- Participants only need to sign each requirement once.
- Participants belongs to households.
- Adults in households can sign on behalf of minor participants.

{% include figure.html url="/assets/images/diagrams/community_erd_1.png" description="Fig 1: Simplified entity relationship diagram" %}

The accompanying Rails[^1] models are relatively straight forward:

```ruby
class Person < ApplicationRecord
  has_many :household_people
  has_many :household
  has_many :program_participants
  has_many :participants, through: :program_participants
end

class Household < ApplicationRecord
  has_many :household_people
  has_many :people, through: :household_people
end

class HouseholdPerson < ApplicationRecord
  belongs_to :household
  belongs_to :person
end

class Program < ApplicationRecord
  has_many :program_participants
  has_many :participants, through: :program_participants
  has_many :program_signature_requirements
  has_many :signature_requirements, through: :program_signature_requirements
end

class ProgramParticipant < ApplicationRecord
  belongs_to :program
  belongs_to :participant, class_name: "Person"
end

class SignatureRequirement < ApplicationRecord
  has_many :program_signature_requirements
  has_many :signatures
end

class ProgramSignatureRequirement < ApplicationRecord
  belongs_to :signature_requirement
  belongs_to :program
end

class Signature < ApplicationRecord
  belongs_to :signature_requirement
  belongs_to :participant
end
```

The relationships fit well with Rails' associations, taking advantage of a few join tables (e.g. `household_people`, `program_participants`, `program_signature_requirements`). The basic user experience (UX) for administrators managing data in the system followed typical [CRUD][2]; It became more complex when creating the UX for participants.

## Finding Pending Requirements

To create the simplest experience possible for parents of program participants, we settled on the following UX:

- A parent is shown a list of pending requirements: This is a list documents the have to (electronically) sign. A pending requirements is one that is associated with a program that at least one user in the household is a participant of. It must also not have been met.
- Once the parent selects the requirements to sign, he can do so with a single submission on behalf of any of the children in the same household, that don't yet have a signature for that requirements.

Inspection of the data modeling reveals that both queries -- pending requirements and eligible participant signatures for a household -- are possible with a single roundtrip (SQL statement) from the database. The query is not trivial. It must join, `household`, `household_people`, `programs`, `program_participants`, `signature_requirements` and `program_signature_requirements` to obtain the set of signature that we _want_ to exist at some point. We also require removing from those list those signatures that already exist. The removal portion suggest to me using a `LEFT JOIN` to the `signatures` table, and filtering `WHERE signatures.id IS NULL` to remove the existing signatures from the set.

I tried writing the queries using `ActiveRecord` in several ways, using joins and sub-selects. I found myself getting results that were not quite correct and having a hard time reasoning about it. The cognitive load of keeping that many things in my head at once was getting the best of me. Fortunately, I recognize the thought pattern, and more importantly the solution: *What can I abstract away to make it easier?*

Eventually I settled on `MissingSignature`: It represents the domain concept of some data that we want to exist, but doesn't. I know of two ways to create data abstraction in relational databases: Common Table Expressions (CTEs) and database views. Both are supported to a certain extent in Ruby on Rails. CTEs are supported through the use of `arel`, which is not considered public API. It can be awkward to mix and with regular `ActiveRecord` queries. Views on the other hand, are mostly treated by rails as tables, and abstract away how the are defined. With the help of the [scenic gem][scenic], defining a view is simple.

```sql
-- db/views/missing_signatures_v01.sql
WITH current_participant_requirements AS (
    SELECT
        "program_signature_requirements"."signature_requirement_id",
        "program_participants"."participant_id"
    FROM
        "program_participants"
        INNER JOIN "program_signature_requirements" ON "program_signature_requirements"."program_id" = "program_participants"."program_id"
        INNER JOIN "programs" ON "programs"."id" = "program_signature_requirements"."program_id"
            AND "programs"."id" = "program_participants"."program_id"
        INNER JOIN "signature_requirements" ON "signature_requirements"."id" = "program_signature_requirements"."signature_requirement_id"
    WHERE
        "signature_requirements"."expires_at" >= now())
SELECT
    cpr.*
FROM
    "current_participant_requirements" cpr
    LEFT JOIN "signatures" ON "signatures"."participant_id" = "cpr"."participant_id"
        AND "signatures"."signature_requirement_id" = "cpr"."signature_requirement_id"
WHERE
    "signatures"."id" IS NULL
```

The above SQL is the source for the `missing_signatures` view. Within that view, there is a CTE for `current_participant_requirements` which does the heavy lifting in terms of joins, and also filters to "current" requirements. We don't care for requirements that have expired, since the don't need to be signed anymore. The CTE makes is easy to split the logic between finding the correct requirements, and then only showing the "pending" ones, via the `LEFT JOIN ... WHERE signatures.id IS NULL`.

With the view in hand, using it in Rails is straightforward:

```ruby
class MissingSignature < ApplicationRecord
  belongs_to :signature_requirement
  belongs_to :participant, class_name: "Person"

  def read_only?
    true
  end
end
```

The `ready_only?` prevents `ActiveRecord` from attempting to write to that view, which would fail anyway. Notice that it can take advantage of regular `ActiveRecord` associations, on both sides:

```ruby
class SignatureRequirements < ApplicationRecord
  # ...
  has_many :missing_signatures
end

class Person < ApplicationRecord
  # ...
  has_many :missing_signatures, inverse_of: :participant, foreign_key: :participant_id
end
```

The resulting ERD diagram, illustrates the relationships:

{% include figure.html url="/assets/images/diagrams/community_erd_2.png" description="Fig 2: ERD with missing signatures)" %}

## Simplified Queries

With our new abstraction in place, the once-complicated queries can now be expressed with regular joins:

```ruby
# Pending Requirements
SignatureRequirement
  .joins(:missing_signatures, programs: {program_participants: :participant})
  .merge(household.people)
  .distinct

# Possible Participants
Person
  .joins(:household_people, :missing_signatures)
  .merge(household_people)
  .merge(MissingSignature.where(signature_requirement_id: signature_requirement.id))
  .distinct
```

Each of the above generates a single SQL statement. The first looks like:

```sql
SELECT DISTINCT
    "signature_requirements".*
FROM
    "signature_requirements"
    INNER JOIN "missing_signatures" ON "missing_signatures"."signature_requirement_id" = "signature_requirements"."id"
    INNER JOIN "program_signature_requirements" ON "program_signature_requirements"."signature_requirement_id" = "signature_requirements"."id"
    INNER JOIN "programs" ON "programs"."id" = "program_signature_requirements"."program_id"
    INNER JOIN "program_participants" ON "program_participants"."program_id" = "programs"."id"
    INNER JOIN "people" ON "people"."id" = "program_participants"."participant_id"
    INNER JOIN "household_people" ON "people"."id" = "household_people"."person_id"
WHERE
    "household_people"."household_id" = 253
```

Without the abstraction, a query that generates the same results, would be possible, but considerably more complex. It would require joining on the same tables multiple times.

## Conclusion

A software abstraction provides more than indirection. It provides a way to reduce cognitive load. It simplifies by allowing us to *not* think about all the details at once. In this example, the domain concept the that was abstracted represents data that has *not* been written to the database; data that is missing. A database view provided a convenient way to integrate to the rest of the tooling.


[1]: https://en.wikipedia.org/wiki/Abstraction_(computer_science)
[2]: https://www.codecademy.com/articles/what-is-crud
[scenic]: https://github.com/scenic-views/scenic
[^1]: Code examples target Ruby on Rails 6.0, using PostgreSQL. Other database engines also support views, but I haven't tried them.
