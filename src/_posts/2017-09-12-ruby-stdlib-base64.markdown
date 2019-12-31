---
layout: post
title: "Ruby stdlib: Base64"
date: 2017-09-12 17:21:36 -0700
comments: true
categories:
- ruby
- stdlib
---

Base64 is a widely-used mechanism to represent binary data in an ASCII string format. There are a few different Base64 schemes that share most of the implementation. The encoding strategy consists of choosing 64 characters that are common to most other string encodings and are also printable. For example, MIME's Base64 implementation uses `A`-`Z`, `a`-`z`, and `0`-`9` for the first 62 characters. Other variations share this property but differ in the characters chosen for the last two values and an extra one for padding. Each base64 digit represents exactly 6 bits of data.

Wikipedia's [Base64 article][wikipedia] has a great explanation of the details of encoding and decoding from Base64.

Base64 is typically used to send binary across channels that are text based like [email][email], [JSON Web Tokens][jot], [SAML Requests and Response][saml], and many more.

Ruby includes the `base64` package in its [standard library][rubydoc], with support for [RFC-2045][2045], [RFC-4648][4648] and ["RFC-4648 Base 64 Encoding with URL and Filename Safe Alphabet"][urlsafe].

It's usage is straight forward:

``` ruby
require "base64"

encoded = Base64.encode64("I'd rather be a hammer than a nail")
# => "SSdkIHJhdGhlciBiZSBhIGhhbW1lciB0aGFuIGEgbmFpbA==\n"

Base64.decode64(encoded)
# => "I'd rather be a hammer than a nail"
```

`Base64` is a module. It can be called directly, like in the previous example or included in other classes:

```ruby
require "base64"

class MyEncoder
  include Base64

  def initialize(binary)
    @binary = binary
  end

  def encode
    urlsafe_encode64(@binary)
  end
end

MyEncoder.new("I'd rather be a hammer than a nail").encode
# => "SSdkIHJhdGhlciBiZSBhIGhhbW1lciB0aGFuIGEgbmFpbA=="
```

Notice that the `urlsafe_encode64` returns slightly different results than `encode64`. See the [Ruby documentation][rubydoc] for details.

You can create your own modules with functions that can be included or called directly, like `Base64` does. Use `module_function`:


```ruby
module Greeter
  def hello
    "Hello, World!"
  end

  module_function :hello
end

class Person
  include Greeter

  def greet
    hello
  end
end


Greeter.hello # => "Hello, World!"
Person.new.greet # => "Hello, World!"
```

[Under the hood][source], `Base64` relies on `Array#pack` ([documentation][pack]) and `String#unpack1` ([documentation][unpack1]) which do the heavy lifting. Both of these methods are implemented in C:

```
pry(main)> show-source Array#pack

From: pack.c (C Method):
Owner: Array
Visibility: public
Number of lines: 621

static VALUE
pack_pack(int argc, VALUE *argv, VALUE ary)
{
  # ... many lines removed
}

pry(main)> show-source String#unpack1

From: pack.c (C Method):
Owner: String
Visibility: public
Number of lines: 5

static VALUE
pack_unpack1(VALUE str, VALUE fmt)
{
    return pack_unpack_internal(str, fmt, UNPACK_1);
}
```

[wikipedia]: https://en.wikipedia.org/wiki/Base64
[email]: https://en.wikipedia.org/wiki/Email
[jot]: https://jwt.io/
[saml]: https://en.wikipedia.org/wiki/Security_Assertion_Markup_Language#Use
[rubydoc]: https://ruby-doc.org/stdlib-2.4.1/libdoc/base64/rdoc/Base64.html
[2045]: https://www.ietf.org/rfc/rfc2045.txt
[4648]: https://tools.ietf.org/html/rfc4648
[urlsafe]: https://tools.ietf.org/html/rfc4648#section-5
[source]: https://github.com/ruby/ruby/blob/trunk/lib/base64.rb
[pack]: https://ruby-doc.org/core-2.4.1/Array.html#method-i-pack
[unpack1]: https://ruby-doc.org/core-2.4.1/String.html#method-i-unpack1
