---
layout: post
title: "I Also Built A CLI Application in Crystal"
date: 2017-03-23 20:52:32 -0700
comments: true
categories:
- crystal
---

Recently, I've read about [porting a Ruby application][1] or [writing a command-line application][2] to Crystal. As it happens, I had started doing the same thing myself a while ago and recently finished it. My motivation was intellectual curiosity. Learning a new language is useful in itself, but I have also found that it learning paradigms in a new language influences how we use other languages as well.

Crystal is inspired by Ruby. Much of it's syntax is the same. Much of the standard library is very similar. It also has it's differences. Mainly it's type system and the fact that it's compiled, as opposed to interpreted.

I decided to write a port of `franklin`, a toy project of mine. I [wrote about it before][franklin-post]. It's [on Github][franklin-rb]. All the code for the port to crystal is [also on Github][franklin-cr].

<!-- more -->

The Tooling
-----------

Crystal ships with a `crystal` executable. It does a lot. It compiles your code. It runs your specs. It sets up new projects (both libraries and executables), it installs your dependencies. I found that command to be well designed out and easy to use. In the ruby world you can achieve the same with a mix of `ruby`, `gem` and `bundler`. I also found it useful to use `make` to create shortcuts for recently used commands, to automate installing dependencies and other odds and ends. The [Makefile][makefile] is self-explanatory.

I found the error messages from the compiler to be generally helpful, although at times very long. Usually, I only needed to read through the last two or three lines to figure out my mistake, Occasionally I did need to read the full backtraces -- which include the relevant source code (your own or the one generated by macros). It shows that the language designers went to some lengths to make error messages readable.

The Type System
---------------

My preferred way of writing code is Outside-In TDD. I start writing the highest-level code first -- guided by tests, with the shape that I want it to have. As I "discover" which components I need and what I want their API to look like, I continue test-driving the individual components.

For example, my initial though of what the entry point to my application would look like (assuming options have already been parsed) was something like this:

``` ruby
module Franklin
  def self.run(search_terms:, config_path:, filter:, io = STDOUT)
    config = Config.from_file(config_path)
    per_library_results = ConcurrentSearch.new(config.libraries).perform(search_terms)
    results = Collate.new.perform(per_library_results)
    filtered_results = TypeFilter.new(filter).perform(results)
    ConsoleReport.new(filtered_results).to_s(io)
  end
end
```

At this point, none of the components actually exist, so you would expect any test that exercises this to raise and error. The corresponding spec, which I call a *smoke spec* can look as simple as this:

```ruby
it "integrates end-to-end" do
  expect {
    Franklin.run(search_terms: "Seveneves",
                 config_path: example_config_path,
                 filter: nil,
                 io: IO::Memory.new)
  }.not_to raise_error
end
```

This approach serves me really well in Ruby. I would proceed to test-drive each of the components. In Crystal, this same approach doesn't work, because of the compiler. Running the spec would result in the compiler complaining that it doesn't now about `Config`, as opposed to a spec failure that can be marked as pending. I can't even test-drive `Config`, because until *all* of the components exists and implement the API, I can't proceed. In that respect, working with a compiler forces you to do Inside-Out TDD: Work on the lowest-level components first.

It became evident pretty quickly that the language itself was pushing me to work differently. I settled on commenting out code as a strategy to enable the code to compile, so that I could continue to test-drive. I didn't love it, but got used to it.

### Method Overload

One of the things I did like about crystal's type system, is the ability to overload methods with different type signatures, to get rid of conditional logic. For example:

```ruby
private def parse(json : Nil)
  {} of Item => Availability
end

private def parse(raw_data : String)
  data = Overdrive::Data.from_json(raw_data).data
  data.each_with_object(result = {} of Item => Availability) do |(id, entry), result|
    result[entry.to_item(id)] = entry.to_availability(library)
  end
rescue JSON::Error
  parse(nil)
```

When calling `parse` it will get dispatched correctly depending on the type of the input. In one case, when we pass a `nil` value, we return an empty data structure. However, if we actually have a value, then we populate the data structure accordingly. I found this allows for clearer reasoning and a more compact way dealing with edge-cases.

Duck-Typing
-----------

In ruby, I often use duck-typing -- passing objects that quack the same, but may not be of the same class. One of it's uses is to be able to inject doubles or mocks in tests that are pre-configured to act in known ways. With a strong-typed language, this can be accomplished with interfaces or abstract classes. I found this to be a good solution. For example:

``` ruby
module SearchInterface
  abstract def perform(search_terms : String) : Hash(Item, Availability)
end

# Concrete implementation, used in production code
class Search
  include SearchInterface
  # ...
end

# Implementation used in specs, which make it easier to inject any results we want
module Test
  class Search
    include SearchInterface

    def initialize(@library : Library, @results : Hash(Item, Availability))
    end

    def perform(search_terms)
      @results
    end
  end
end
```

And the code that actually uses the `SearchInterface`:


``` ruby
class ConcurrentSearch
  property searchers : Array(SearchInterface)

  def initialize(@libraries : Array(Library))
    @searchers = @libraries.map { |library| Search.new(library).as(SearchInterface) }
  end
  # ....
end
```

The `searchers` property can now be set in the specs to an Array of `Test::Search`. The `.as_(SearchInterface)` is how crystal does casting. It ensures that type system doesn't complain of a type mismatch.

Macros
------

Using some of the built-in macros was a very pleasant experience. In particular the `mapping` macros for reading JSON and YAML into data structures really shines. Take reading the configuration:

```ruby
class Config
  YAML.mapping(
    libraries: Array(Library),
    default_type: {
      type: String,
      nilable: true
    }
  )
end

struct Library
  YAML.mapping(
    name: String,
    url: String
  )
end
```

The two `mapping` directives above will ensure that `Config.from_yaml(string)` returns a `Config` class, complete with values cast from YAML correctly to their respective types. The input for that looks like:

```
libraries:
  - name: San Francisco Public Library
    url: http://sfpl.lib.overdrive.com
  - name: San Diego Public Library
    url: http://sdpl.lib.overdrive.com
default_type: eBook
```

JSON parsing also provides a `mapping` method that works much the same way, even ignoring extra keys that are not mapped. I ran into a small hiccup because the data I was parsing looked like this:

```js
{ "123": {...}, "456": {...} }
```

The data contained item ids as top-level keys. Crystal expects JSON keys to be known ahead of time, which in this case we don't. I ended up manipulating the data before parsing so that it looked like this:

```js
{ "data": { "123": {...}, "456": {...} } }
```

After that, it was possible to define the JSON mappings like this:

``` ruby
struct Data
  JSON.mapping(
    data: Hash(String, Entry)
  )
end

struct Entry
  JSON.mapping(
    title: String,
    # other fields defined here
  )
end
```

Maturity
--------

The crystal ecosystem is still young and developing. It is to be expected for a language that has not yet reached 1.0. Depending on your needs, it can get in the way.

For the last 5 years, I have been writing all my tests in RSpec. I have a lot of muscle memory and the DSL is ingrained in how I think about tests. Crystal ships with a testing library, which uses the *should* syntax that has now fallen out-of-favor with RSpec users. I found the [Spec2][spec2] library to be a good substitute. Using external libraries is very easy. What in ruby are called gems, in crystal are called shards. Dependencies are declared in `shard.yml` and crystal takes care of resolving, downloading and locking them in `shard.lock`. I didn't have any problem with that part. It seemed a bit weird to me that Github is used as the source of all dependencies (other git servers can be used), as opposed to an official repository. I wonder if that will scale.

As my project involves scraping HTML, I tried to use something similar to `mechanize` in ruby, but didn't find anything that seemed suitable. I settled on a http client called [cossack][cossack]. It seemed very similar to Faraday and seemed to work fine. However, when building the project with the `--release` flag, it would blow up. I tried coming up with a minimal reproduction so I could let the author know (and potentially fix it), but my debugging skills in crystal are still poor. I ended up removing that dependency and using the standard library http client. It proved sufficient for my needs. It made me realize that using `mechanize` in the Ruby version of this project is unnecessary and I am planning on removing that dependency.

While in the subject of http: I generally like to test http interactions in my code with [VCR][vcr]. It records all http interactions in tests and plays them back on subsequent spec runs. This stop your tests from hitting an external service on every run (speeding them up), while giving you some assurances that you are handling the output of that system correctly. The downside is that the external system can drift in it's responses from the ones recorded and your code may no longer handle responses appropriately. In any case, I didn't find a similar library for crystal. The best I could do is use a [mocking library][mock]. I manually downloaded html returned from the external systems and replaced the saved html for responses using mocks:

```ruby
describe ".run" do
  let(:example_config_path) { File.join(__DIR__, "example_franklin_config.yml") }
  let(:response_body) { File.read("spec/seveneves_search.html") }

  it "integrates end-to-end" do
    # Recorded search, replayed to avoid network traffic in testing
    WebMock.stub(:get, "https://sfpl.overdrive.com/search?query=Seveneves")
           .to_return(body: response_body)

    expect {
      Franklin.run(search_terms: "Seveneves",
                   config_path: example_config_path,
                   filter: nil,
                   io: IO::Memory.new)
    }.not_to raise_error
  end
```

Not quite as slick as using VCR, but effective nonetheless. From a thread in the crystal mailing list, I gather that `webmock` is written by the authors of crystal itself and will at some point be part of the standard library.

Conclusion
----------

I enjoyed writing the app in crystal. In a lot of ways, it feels like writing Ruby. The type system is definitely a big part of the language. The compiled binary runs much faster than ruby. I ran an informal benchmark. It consisted of hitting a single endpoint in four external services, parsing the results, and printing them out to the console. The ruby version averages 2.6 seconds per run. The crystal version averages 0.3 seconds. The difference is staggering. Even more so, considering that I expect most of the 0.3 seconds was spent in network transfer.

I don't have a current project for which I think crystal is appropriate. I will keep in in mind next time I need to write a CLI or want to speed up Ruby with a native extension. It also is worth keeping an eye on [Kemal][kemal], a Sinatra-like crystal framework.

[1]: http://squarism.com/2017/02/25/porting-ruby-to-crystal/
[2]: https://jclem.net/posts/building-a-command-line-application-with-crystal
[crystal]: https://crystal-lang.org/
[franklin-post]: /blog/2016/01/28/scratching-an-itch-with-a-gem/
[franklin-rb]: https://github.com/ylansegal/franklin
[franklin-cr]: https://github.com/ylansegal/franklin.cr
[makefile]: https://github.com/ylansegal/franklin.cr/blob/master/Makefile
[spec1]: https://github.comw/aterlink/spec2.cr
[cossack]: https://github.com/greyblake/crystal-cossack
[vcr]: https://github.com/vcr/vcr
[mock]: https://github.com/manastech/webmock.cr
[kemal]: http://kemalcr.com/