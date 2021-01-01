---
layout: post
title: "Abstractions With Database Views"
# date: 2020-01-14 16:26:07 -0800
categories:
- rails
- databases
excerpt:
---

Wikipedia defines a [software abstraction][1] as:

> In software engineering and computer science, abstraction is...
the process of removing physical, spatial, or temporal details or attributes in the study of objects or systems to focus attention on details of greater importance; it is similar in nature to the process of generalization;

A database view can provide a useful abstraction; a concept that represents something in a domain. Recently, I had the opportunity to do use a view to create an abstraction, to represent data that is *missing* from the database.

I'm working on a system that tracks program participation for a community center. The relevant characteristic here are:
- Each program can have many participant.
- Programs can also have signature requirements: They are digital agreement that participants "sign". They can't participate in the program without them.
- It's important for the community center staff to track the signatures, and which participants have not fulfilled the requirements. Several programs can share the same signature requirement (e.g. for a code of conduct).
- Participants only need to sign each requirement once.
- Participants belongs to households.
- Adults in houesholds can sign on behalf of minor participants.

{% include figure.html url="/assets/images/diagrams/community_erd_1.png" description="Fig 1: Simplified entity relationship diagram" %}

The accompanying Rails[^1] models are relatively straight forward:

```ruby
class Person < ApplicationRecord
  has_many :household_people
  has_many :household
  has_many :program_participants
  has_many :participants, through: :program_participants
end

def Household < ApplicationRecord
  has_many :household_people
  has_many :people, through: :household_people
end

def HouseholdPerson < ApplicationRecord
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

The relationships are relatively straight-forward, taking advantage of a few join tables (e.g. `household_people`, `program_participants`, `program_signature_requirements`). The basic user experience (UX) for administrators managing data in the system followed typical [CRUD][2]; It became more complex when creating the UX for participants.

## Finding Pending Requirements

To create the simplest experience possible for parents of program participants, we settled on the following UX:

- A parent is shown a list of pending requirements: This is a list documents the have to (electronically) sign. A pending requirements is one that is associated with a program that at least one user in the household is a participant of. It must also not have been met.
- Once the parent selects the requirements to sign, he can do so with a single submission on behalf of any of the children in the same household, that don't yet have a signature for that requirements.

Inspection of the data modeling reveals that both queries -- pending requirements and eligible participant signatures for a household -- are possible with a single roundtrip (SQL statement) from the database. The query is not trivial. It must join, `household`, `household_people`, `programs`, `program_participants`, `signature_requirements` and `program_signature_requirements` to obtain the set of signature that we _want_ to exist at some point. We also require removing from those list those signatures that already exist. The removal portion suggest to me using a `LEFT JOIN` to the `signatures` table, and filtering `WHERE signatures.id IS NULL`. That removes the existing signatures from the set.

I tried writing the queries using `ActiveRecord` in several way, using joins and sub-selects, but found myself getting results that were not quite correct and having a hard time reasoning about it. The cognitive load of keeping that many things in my head at once was getting the best of me. Fortunately, I recognize the thought pattern, and the solution: Asking myself, what is the missing abstraction.

Eventually I would settle on `MissingSignature`: It represents the domain concept of some data that we want to exist, but doesn't. I know of two ways to create data abstraction in relational databases: Common Table Expressions (CTEs) and database views. Both are supported to a certain extent in Ruby on Rails, but CTEs only through the use of `arel`, which is not considered public API, and can be awkward to mix and with regular `ActiveRecord` relations. Views on the other hand, are mostly trated by rails as tables, and abstract away how the are defined.



[1]: https://en.wikipedia.org/wiki/Abstraction_(computer_science)
[2]: https://www.codecademy.com/articles/what-is-crud
[^1]: Code examples target Ruby on Rails 6.0
