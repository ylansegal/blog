---
layout: post
title: "Avro Schema Evolution"
date: 2020-05-26 10:52:44 -0700
categories:
- avro
- kafka
excerpt_separator: <!-- more -->
---

I'm involved in an ambitious project to split a monolith into a service-oriented architecture connected via a stream of events using Kafka topics. Kafka is agnostic to the data serialization format used, and I've been looking at [Avro][avro] in particular.

Avro -- like [Protocol Buffers][protobuf] and [Thrift] -- is a binary format, making it more space-efficient than a text and verbose format like [JSON][json]. It stands out in that it's schema support logical and complex types, and it's decoupling between the *writer's schema* and the *reader's schema*, which provides flexibility.

The schema for an application's data is expected to change over time. In database-backed applications, this is typically done by changing the data shape with a *migration*. I've written about how [deploying schema migrations][deploying_schema_migrations] needs to be though of carefully. In that article I covered a few different strategies, but they all shared a common trait: *All* the data has one shape before the migrations, and a different one afterwards. That is incompatible with applications that rely on an *immutable log*. Let's explore Avro's schema evolution.

<!-- more -->

## An Example Schema

We'll start our example with an Avro schema for a `CatalogItem`, an example entity that could be used in an e-commerce application. The schema is defined in JSON:

```json
{
  "type": "record",
  "name": "CatalogItem",
  "fields": [{
      "name": "id",
      "type": "long"
    },
    {
      "name": "description",
      "type": "string"
    },
    {
      "name": "price",
      "type": "bytes",
      "logicalType": "decimal",
      "precision": "30",
      "scale": "12"
    }
  ]
}
```

A robust application will have some sort of schema registry. For the purpose of this example, I will hide that complexity and implement the simplest thing that works:

```ruby
require 'avro'

module SchemaRegistry
  V1 = Avro::Schema.parse(V1_JSON)
end
```

Avro's Ruby library is very verbose. Let's abstract away some of the boilerplate:

```ruby
module AvroHelper
  def self.serialize(writers_schema, datum)
   target = StringIO.new
   writer = Avro::IO::DatumWriter.new(writers_schema)
   encoder = Avro::IO::BinaryEncoder.new(target)

   writer.write(datum, encoder)

   target.string
  end

  def self.deserialize(writers_schema, readers_schema, encoded_data)
   source = StringIO.new(encoded_data)
   reader = Avro::IO::DatumReader.new(writers_schema, readers_schema)
   decoder = Avro::IO::BinaryDecoder.new(source)

   reader.read(decoder)
  end
end
```

## Serializing and De-serializing Messages

The basics of Avro in action:

```ruby
message_1 = {
  "id" => 1,
  "description" => "iPhone SE",
  "price" => "399.99"
}

Avro::Schema.validate(SchemaRegistry::V1, message_1)
# => true

encoded_message_1 = AvroHelper.serialize(SchemaRegistry::V1, message_1)
# => "\u0002\u0012iPhone SE\f399.99"

AvroHelper.deserialize(
  SchemaRegistry::V1,
  SchemaRegistry::V1,
  encoded_message_1
)
# => {"id"=>1, "description"=>"iPhone SE", "price"=>"399.99"}
```

As we can see, we can roundtrip data to and from Avro. When de-serializing, both the writer's and reader's schema need to be provided, even id they are the same, as in the example above.

## Message Evolution

Our fictional e-commerce application is ready to take over the world. We need support for multi-currency in our application. Let's add a currency field for `V2` of our `CatalogItem`

```json
{
  "type": "record",
  "name": "CatalogItem",
  "fields": [{
      "name": "id",
      "type": "long"
    },
    {
      "name": "description",
      "type": "string"
    },
    {
      "name": "price",
      "type": "bytes",
      "logicalType": "decimal",
      "precision": "30",
      "scale": "12"
    },
    {
      "name": "currency",
      "type": "string",
      "default": "USD"
    }
  ]
}
```

```ruby
module SchemaRegistry
  V2 = Avro::Schema.parse(V2_JSON)
end
```

We've added an `currency` field with a default value. This gives us backward-compatibility. We can continue reading existing messages with the new schema.

```ruby
AvroHelper.deserialize(
  SchemaRegistry::V1,
  SchemaRegistry::V2,
  encoded_message_1
)
# => {"id"=>1,
#     "description"=>"iPhone SE",
#     "price"=>"399.99",
#     "currency"=>"USD"}

Avro::SchemaCompatibility.can_read?(SchemaRegistry::V1, SchemaRegistry::V2)
# => true
```

The original `message_1` did not include a `currency` field, but when converting to a `V2` schema the default kicks. What about the other way around?

```ruby
message_2 = {
  "id" => 2,
  "description" => "Pixel 3",
  "price" => "279.00",
  "currency" => "MXN"
}

encoded_message_2 = AvroHelper.serialize(SchemaRegistry::V2, message_2)
# => "\u0004\u000EPixel 3\f279.00\u0006MXN"

AvroHelper.deserialize(
  SchemaRegistry::V2,
  SchemaRegistry::V1,
  encoded_message_2
)
# => {"id"=>2, "description"=>"Pixel 3", "price"=>"279.00"}

Avro::SchemaCompatibility.mutual_read?(SchemaRegistry::V1, SchemaRegistry::V2)
# => true
```

Avro considers this change to be forward-compatible: The messages written by a later schema are readable by a previous schema. Since `currency` is an optional field, Avro's [resolution rules][resolution_rules] dictate that it can be ignored when reading in `V1` schema. `message_2` was written with a `currency` value of `MXN`, but read without one. More than likely, our business logic would assume that the currency would be `USD`. This is a potential source of bugs, and up to the developer to correctly handle this type of situation.

Forging ahead, let us now consider that we want to make the `currency` field a required one. Our `V3` schema is now:

```json
{
  "type": "record",
  "name": "CatalogItem",
  "fields": [{
      "name": "id",
      "type": "long"
    },
    {
      "name": "description",
      "type": "string"
    },
    {
      "name": "price",
      "type": "bytes",
      "logicalType": "decimal",
      "precision": "30",
      "scale": "12"
    },
    {
      "name": "currency",
      "type": "string"
    }
  ]
}
```

```ruby
module SchemaRegistry
  V3 = Avro::Schema.parse(V3_JSON)
end
```

Is `V3` backwards-compatible with previous schemas?

```ruby
Avro::SchemaCompatibility.can_read?(SchemaRegistry::V1, SchemaRegistry::V3)
# => false

AvroHelper.deserialize(
  SchemaRegistry::V1,
  SchemaRegistry::V3,
  encoded_message_1
) rescue $!
# => #<Avro::AvroError: Missing data for "string" with no default>

Avro::SchemaCompatibility.can_read?(SchemaRegistry::V2, SchemaRegistry::V3)
# => true

AvroHelper.deserialize(
  SchemaRegistry::V2,
  SchemaRegistry::V3,
  encoded_message_2
)
# => {"id"=>2, "description"=>"Pixel 3", "price"=>"279.00", "currency"=>"MXN"}
```

`V3` is backward-compatible with `V2`, but not `V1`. The `currency` field is expected, but it's not there.

## Evolving Topics

A path of reconciling backwards-compatible changes, is to evolve the messages in a topic and write them to a new topic. This is known as [Copy and Replace][copy_and_replace].  Let's model a topic by using an array of objects that contain messages accompanied by the writer's schema:

```ruby
v1_events = [
  {
    writers_schema: 'SchemaRegistry::V1',
    message: encoded_message_1
  },
  {
    writers_schema: 'SchemaRegistry::V2',
    message: encoded_message_2
  }
]

v1_events.map { |wrapper|
  AvroHelper.deserialize(
    Object.const_get(wrapper[:writers_schema]),
    SchemaRegistry::V2,
    wrapper[:message]
  )
}
# => [{"id"=>1,
#      "description"=>"iPhone SE",
#      "price"=>"399.99",
#      "currency"=>"USD"},
#     {"id"=>2,
#      "description"=>"Pixel 3",
#      "price"=>"279.00",
#      "currency"=>"MXN"}]
```

As expected, the topic is backwards-compatible with `V1`. We know that `V3` is backward-compatible with `V2`, so we can create a new topic and evolve all the events:

```ruby
v2_events = v1_events.map { |wrapper|
    AvroHelper.deserialize(
    Object.const_get(wrapper[:writers_schema]),
    SchemaRegistry::V2,
    wrapper[:message]
  )
}.map { |datum|
  {
    writers_schema: 'SchemaRegistry::V2',
    message: AvroHelper.serialize(SchemaRegistry::V2, datum)
  }
}
# => [{:writers_schema=>"SchemaRegistry::V2",
#      :message=>"\u0002\u0012iPhone SE\f399.99\u0006USD"},
#     {:writers_schema=>"SchemaRegistry::V2",
#      :message=>"\u0004\u000EPixel 3\f279.00\u0006MXN"}]
```

As expected, the topic can be read correctly in `V3`:

```ruby
v2_events.map { |wrapper|
  AvroHelper.deserialize(
    Object.const_get(wrapper[:writers_schema]),
    SchemaRegistry::V3,
    wrapper[:message]
  )
}
# => [{"id"=>1,
#      "description"=>"iPhone SE",
#      "price"=>"399.99",
#      "currency"=>"USD"},
#     {"id"=>2,
#      "description"=>"Pixel 3",
#      "price"=>"279.00",
#      "currency"=>"MXN"}]
```

In fact, because we *"hydrated"* the default currency values from `V2`, we can evolve all the messages to `V3`. Consumers in `V2` will continue to be able to read the values (`V3` is forward-compatible), because we ensured that default values were written to all messages.

```ruby
v3_events = v1_events.map { |wrapper|
    AvroHelper.deserialize(
    Object.const_get(wrapper[:writers_schema]),
    SchemaRegistry::V2,
    wrapper[:message]
  )
}.map { |datum|
  {
    writers_schema: 'SchemaRegistry::V3',
    message: AvroHelper.serialize(SchemaRegistry::V3, datum)
  }
}

v3_events.map { |wrapper|
  AvroHelper.deserialize(
    Object.const_get(wrapper[:writers_schema]),
    SchemaRegistry::V2,
    wrapper[:message]
  )
}
# => [{"id"=>1,
#      "description"=>"iPhone SE",
#      "price"=>"399.99",
#      "currency"=>"USD"},
#     {"id"=>2,
#      "description"=>"Pixel 3",
#      "price"=>"279.00",
#      "currency"=>"MXN"}]
```

Interestingly, because of how Avro serializes to binary, supplied optional fields and required fields are serialized in exactly the same way. The transformation from the hydrated `V2` to `V3` is a no-op:

```ruby
v2_events == v3_events
# => false
```

# Evolving Topics Without "Copy and Replace"

"Copy and Replace" poses operational concerns: How do we coordinate the copying of all events to a new topic and the writing of new incoming events, without sacrificing the order? In the previous example `v1_events` was evolved into `v2_events` (and the identical `v3_events`) because we knew that the each Avro schema was backward-compatible. We can encode that knowledge into our registry:

```ruby
module SchemaRegistry
  EVOLUTION = [
    'SchemaRegistry::V1',
    'SchemaRegistry::V2',
    'SchemaRegistry::V3'
  ]
end
```

With that in place, we can evolve each message to the latest version at read-time:

```ruby
module AvroHelper
  # This code works, but is not optimized. It serializes and de-serializes the
  # messages more than strictly necessary.
  def self.evolve_to_latest(evolution, writers_schema:, message:)
    (evolution.index(writers_schema)..(evolution.size - 1)).reduce(message) { |encoded, schema_index|
      current_schema = Object.const_get(evolution[schema_index])
      next_schema = Object.const_get(evolution[schema_index + 1] || evolution.last)
      serialize(next_schema, deserialize(current_schema, next_schema, encoded))
    }.then { |encoded|
      latest_schema = Object.const_get(evolution.last)
      deserialize(latest_schema, latest_schema, encoded)
    }
  end
end

message_3 = {
  "id" => 3,
  "description" => "Galaxy S20",
  "price" => "800.00",
  "currency" => "EUR"
}

v1_events << {
  writers_schema: 'SchemaRegistry::V3',
  message: AvroHelper.serialize(SchemaRegistry::V3, message_3)
}

v1_events.map { |wrapper|
  AvroHelper.evolve_to_latest(SchemaRegistry::EVOLUTION, **wrapper)
}
# => [{"id"=>1,
#      "description"=>"iPhone SE",
#      "price"=>"399.99",
#      "currency"=>"USD"},
#     {"id"=>2,
#      "description"=>"Pixel 3",
#      "price"=>"279.00",
#      "currency"=>"MXN"},
#     {"id"=>3,
#      "description"=>"Galaxy S20",
#      "price"=>"800.00",
#      "currency"=>"EUR"}]
```

## Conclusions

Avro makes a distinction between the schema used to write a message and the schema used to read it. Its resolution rules dictate the behavior. The separation of schema and serialized message implies that care must be taken that metadata about the serialized message be carried with it, so that the writer's schema can be resolved.

Avro schema evolution doesn't not solve all compatibility issues: The business rules for an acceptable schema evolution might be different than what Avro considers compatible, as illustrated by the `V1` forward compatibility with `V2` messages.

In database-backed applications, schema changes often require modifying existing records (e.g. "back-fills"). In message-broker-backed applications, it's typical to have an immutable log of events. Forcing all consumers to be able to deal with every version of the event schema is burdensome, and error prone. A way to reconcile that is by using "Copy and Replace" to populate new, equivalent topics. Alternatively, we can design schema versions that are backward-compatible with consecutive version. We can encode the version evolution in a registry. Then evolve each message at [read-time][^1] as necessary. This approach results in a reduction of the numbers of topics that need to be created, and the complexity of managing cut-offs.

[^1]: In fact, newer versions of Postgres support a kind of read-time evolutions: When altering a table and adding a default value, Postgres no longer rewrites every entry in the table. Instead, at read-time if the value is not written in the row, it will look-up the default value.

[avro]: https://avro.apache.org/
[protobuf]: https://developers.google.com/protocol-buffers/
[thrift]: https://thrift.apache.org/
[json]: https://www.json.org/json-en.html
[deploying_schema_migrations]: {% post_url 2020-01-14-deployments-with-schema-migrations %}
[resolution_rules]: https://avro.apache.org/docs/1.8.0/spec.html#Schema+Resolution
[copy_and_replace]: https://leanpub.com/esversioning/read#leanpub-auto-copy-and-replace
