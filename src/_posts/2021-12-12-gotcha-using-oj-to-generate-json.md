---
layout: post
title: "Gotcha using Oj to generate JSON"
date: 2021-12-12 11:59:08 -0800
categories:
- ruby
- rails
excerpt_separator: <!-- more -->
---

[Oj](http://www.ohler.com/oj/) is a Ruby gem that bills itself as a faster way to generate JSON, mainly through the use of a C extension. I recently found it was generating unexpected results.

I was looking through a report that one of our endpoints was generating unusually large JSON payloads. In particular, timestamps where being serialized to a very verbose (and not very useful format):

```json
{
  "created_at": {
    "^o": "ActiveSupport::TimeWithZone",
    "utc": {
      "^t": 1639339673.031328000
    },
    "time": null,
    "time_zone": {
      "^o": "ActiveSupport::TimeZone",
      "name": "UTC",
      "utc_offset": null,
      "tzinfo": {
        "^o": "TZInfo::DataTimezone",
        "info": {
          "^o": "TZInfo::ZoneinfoTimezoneInfo",
          "identifier": "Etc/UTC",
          "offsets": {
            "^#1": [0, {
              "^o": "TZInfo::TimezoneOffset",
              "utc_offset": 0,
              "std_offset": 0,
              "abbreviation": ":UTC",
              "utc_total_offset": 0
            }]
          },
          "transitions": [],
          "previous_offset": {
            "^o": "TZInfo::TimezoneOffset",
            "utc_offset": 0,
            "std_offset": 0,
            "abbreviation": ":UTC",
            "utc_total_offset": 0
          },
          "transitions_index": null
        }
      }
    },
    "period": null
  }
}
```

I quickly saw that the controller was invoking `Oj` directly, and that is the root of the problem. The library has a Rails compatibility mode, that is not the default:

```ruby
ts = Time.zone.now

ts.to_json
# => "\"2021-12-12T20:10:56Z\""

Oj.dump(ts)
# => "{\"^o\":\"ActiveSupport::TimeWithZone\",\"utc\":{\"^t\":1639339856.001998000},\"time\":{\"^t\":1639339856.001998000},\"time_zone\":{\"^o\":\"ActiveSupport::TimeZone\",\"name\":\"UTC\",\"utc_offset\":null,\"tzinfo\":{\"^o\":\"TZInfo::DataTimezone\",\"info\":{\"^o\":\"TZInfo::ZoneinfoTimezoneInfo\",\"identifier\":\"Etc/UTC\",\"offsets\":{\"^#1\":[0,{\"^o\":\"TZInfo::TimezoneOffset\",\"utc_offset\":0,\"std_offset\":0,\"abbreviation\":\":UTC\",\"utc_total_offset\":0}]},\"transitions\":[],\"previous_offset\":{\"^o\":\"TZInfo::TimezoneOffset\",\"utc_offset\":0,\"std_offset\":0,\"abbreviation\":\":UTC\",\"utc_total_offset\":0},\"transitions_index\":null}}},\"period\":{\"^o\":\"TZInfo::TimezonePeriod\",\"start_transition\":null,\"end_transition\":null,\"offset\":{\"^o\":\"TZInfo::TimezoneOffset\",\"utc_offset\":0,\"std_offset\":0,\"abbreviation\":\":UTC\",\"utc_total_offset\":0},\"utc_total_offset_rational\":null}}"

Oj.dump(ts, mode: :rails)
# => "\"2021-12-12T20:10:56Z\""
```

Adding `mode: :rails` to the `Oj` call fixed the unexpected payload size issue.

The fact that we had a production endpoint generating unexpected JSON for months lets me know two things:
- There is no test coverage that checks the generated JSON against a known schema
- Consumers of this internal endpoint have no use for the timestamps that were being sent down: There is no code that recognizes that data structure.
