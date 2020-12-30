---
layout: post
title: "Abstractions With Database Views"
# date: 2020-01-14 16:26:07 -0800
categories:
- rails
- databases
# excerpt:
---

A database view can provide a useful abstraction; a concept that represents something in a domain. Sometimes, it can even represent data that is missing.

I'm working on a system that tracks program participation for a community center. Each program can have many participant. Programs can also have signature requirements: They are digital agreement that participants "sign". They can't participate in the program without them. It's important for the community center staff to track the signatures, and which participants have not fulfilled the requirements. Several programs can share the same signature requirement (e.g. for a code of conduct). Participants only need to sign each requirement once.

{% include figure.html url="/assets/images/diagrams/community_erd_1.png" description="Fig 1: Simplified entity relationship diagram" %}

The accompanying Rails[^1] models are relatively straight forward:

```ruby
class Person < ApplicationRecord
  has_many :program_participants
  has_many :participants, through: :program_participants
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

The relationships are relatively straight-forward, but some of the queries necessary to drive the user interactions were more complicated.

## Finding Pending Requirements


## Finding Elegible Participants to Fulfill a Requirement


[^1]: Code examples target Ruby on Rails 6.0
