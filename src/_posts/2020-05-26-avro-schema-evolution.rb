V1_JSON = <<~JSON
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
JSON

require 'avro'

module SchemaRegistry
  V1 = Avro::Schema.parse(V1_JSON)
end


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

###

V2_JSON = <<~JSON
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
JSON

###

module SchemaRegistry
  V2 = Avro::Schema.parse(V2_JSON)
end

###

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

###

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

###

V3_JSON = <<~JSON
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
JSON

module SchemaRegistry
  V3 = Avro::Schema.parse(V3_JSON)
end

###

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

###

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

###

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

###

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

###

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


###

v2_events == v3_events
# => false


###

module SchemaRegistry
  EVOLUTION = [
    'SchemaRegistry::V1',
    'SchemaRegistry::V2',
    'SchemaRegistry::V3'
  ]
end

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
