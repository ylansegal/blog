---
layout: post
title: "Scratching An Itch With A Gem"
date: 2016-01-28 08:34:33 -0800
comments: true
categories:
- ruby
---

I love to read. I enjoy novels, science fiction, non-fiction, science and history. I also read a few technical books per year, which I review on [this very blog][1]. I was a bit late to the ebook party and preferred physical books. I received a Kindle as a gift for my birthday 3 years ago. From then on, I have been a convert: I love my Kindle and bring it everywhere.

I am also a patron of my local public library, and soon after I became an e-reader I discovered that they have an ebook selection as well!

# The Itch

In California, membership to public libraries is open to any California resident, regardless of the actual city or county that they actually reside in. Usually, one can get a library card, and the benefits that come with it, by walking in to a branch and showing your driver's license. I have done this procedure with a few libraries: San Diego Public Library (city), San Diego County Library, Los Angeles County Library and the San Francisco Public Library.

It turns out, that all of those libraries use the same ebook catalog: A service called [Overdrive][2]. Each library has a separate URL, with different authentication mechanism, but that is visibly the same website, branded for each library and containing a different catalog of books (and audiobooks, too). Each library carries a different selection of books, with different number of "copies", according to each libraries budget, I assume.

<!-- more -->

Every time I am interested in finding a particular book, I check in one of the website to see if it's available. If it is not in the catalog or there is a wait time, I open a new browser time and repeat with the next library. The procedure goes on until I either find a copy to download or the libraries with the least number of patrons on the waiting list (per copy).

This was barely tolerable when I was doing this for my books only. Now that my two oldest kids are routinely reading ebooks, it was more than I could handle.

At this point, it seemed that spending a few hours researching and writing a tool to automate the searching would be worth my while. I figured that I could write a command-line utility that would take some search terms, send the queries to each library, aggregate the results and present them in text format.

# Using The API

Overdrive has a few different [web-facing APIs][3], that seem would be easy to integrate with. As expected, the use of their API requires registration, unfortunately it also requires approval:

> Approval will be based on the applicant having an existing customer relationship with OverDrive, or applying as a third-party developer agent for an OverDrive customer

It looked like my chances of approval where slim. I thought for a few days on who to pitch the utility so that it would seem like a good idea to Overdrive, all the time thinking that one of the most novel uses of the web in recent years came when APIs where made available without restrictions and "mash-ups" came about. Clearly, the Overdrive folks where not very impressed by this.

In any case, it occurred to me that I was already using an API. One that was made available to me, as a library card holder. This API uses HTML documents, transported over HTTP or HTTPS and presented to me via my browser. This API is their website. It is expected that I would use it interactively, but there is nothing really preventing me from using it programmatically.

# Web Scraping

I am referring to what is commonly known as web-scraping: Programmatically, loading a website and extracting data from the HTML document. Parsing HTML is not very different than parsing JSON, XML or the other usual data formats used in web APIs. This same idea has been [explored before][4].

Data APIs are expected to be consumed by machines and thus are usually more stable, use version numbers and provide other conveniences so that existing programs do not brake. Website, on the other hand, are expected to be consumed by people, that can handle variations in document structure and presentation without skipping a beat. This makes websites owners less likely to fret over structural changes.

However, I think that in this case, that risk is tolerable. For one, this is not mission-critical code: If it stops working, it's not a big deal. Also, from years of using Overdrive's websites, it seems that they don't ever change. They probably have thousands of deployments using the same HTML documents with different CSS. I don't think they are changing any time soon.

# Creating a Gem

Once I decided to start coding, I needed a library name. I settled on `franklin`, which was not taken as a gem name in [RubyGems][5]. It is named after the second most famous librarian according to Google: Benjamin Franklin. (After Laura Bush, who knew?).

`bundler` is usually used to manage a project's dependencies, but also includes a facility to create gem skeleton, including rake tasks for building and deploying, license selection and even bootstraping `minitest` or `rspec` for testing.

``` bash
$ bundle gem franklin
```

# Build Small Things

I decided that for this gem, I would try to keep the number of dependencies at a minimum and work with small, single-purpose objects. To that end, I created a few data-encapsulation objects, which were then later used by "use cases" or objects that performed actions. At a high level, I figured that when run, the command would need to read some sort of configuration file with a list of libraries, search those libraries for a certain term, combine the results and present them on screen. From a high level, the code I wanted to write in library entry point would look something like this:

``` ruby
module Franklin
  def run(search_terms, out)
    config = Config.load_from_file
    individual_results = config.libraries.map { |library|
      Search.new(library).perform(search_terms)
    }
    collated_results = Collate.new.perform(individual_results)
    ConsoleReport.new(search_terms, collated_results).print_to_out(out)
  end
end
```

Of course, none of this code really existed yet, but it provides a template of which object my system needs. The process, I follow lately usually involves writing the code that coordinates or orchestrates a bunch of other objects and let that guide me to which objects need to exist in my system and what tests I need to write. The first release of `franklin` shipped with an entry point that is not very different than the above:

``` ruby
module Franklin
  def run(config_path, search_terms, out)
    config = Config.load_from_file(config_path)
    results = ThreadedSearch.new(config.libraries).perform(search_terms)
    ConsoleReport.new(search_terms, results).print_to_out(out)
  end

  module_function :run
end
```

## Searching

The meat of the application is searching the Overdrive website and parsing the resulting HTML document into a data structure that is easier to work with. Ruby's standard library contains enough to accomplish this task, but I decided that dealing with cookies and other things that a browser does for us was more than I wanted to take on. The single runtime dependency that the gem ships with is `mechanize`.

> The Mechanize library is used for automating interaction with websites. Mechanize automatically stores and sends cookies, follows redirects, and can follow links and submit forms. Form fields can be populated and submitted. Mechanize also keeps track of the sites that you have visited as a history.

Using `mechanize` and `nokogiri`, one of its dependencies to parse HTML turned out to be a simple affair. Most of the time was really spent inspecting HTML and crafting the appropriate XPATH query to get at each data element:

``` ruby
module Franklin
  class Search
    def initialize(library)
      @library = library
    end

    def perform(search_term)
      results = search_library(search_term)
      parse_results(results)
    end

    private

    attr_reader :library

    def search_library(search_term)
      form = prepare_form(search_term)
      form.submit
    end

    def prepare_form(search_term)
      ::Mechanize.new.get(library.url).forms.first.tap { |form|
        form.FullTextCriteria = search_term
      }
    end

    def parse_results(results)
      results.search("div.containAll").each_with_object({}) { |container, result|
        result[parse_item(container)] = parse_availability(container)
      }
    end

    def parse_item(container)
      item_info = container.css("a.share-links").first.attributes
      id = item_info["data-sharecrid"].value
      title = item_info["data-sharetitle"].value
      author = item_info["data-sharecreator"].value

      format = container.css("span.tcc-icon-span").first.attributes["data-iconformat"].value

      Item.new(id, title, author, format)
    end

    def parse_availability(container)
      copies_info = container.css("div.img-and-info-contain.title-data").first.attributes

      total_copies = copies_info["data-copiestotal"].value.to_i
      available_copies = copies_info["data-copiesavail"].value.to_i
      wait_list_size = copies_info["data-numwaiting"].value.to_i

      Availability.new(library, total_copies, available_copies, wait_list_size)
    end
  end
end
```

## VCR

In order to test the search functionality, I used the `vcr` gem, which allows recording of HTTP interactions during a test run and replaying of that same interaction on future runs. This results in deterministic tests, that don't always depend on current network conditions but that will fail if any *unexpected* interactions occur. The test themselves, then look like this:

``` ruby
require "spec_helper"

module Franklin
  describe Search do
    describe "#perform", vcr: true do
      subject { described_class.new(library) }
      let(:library) { Library.fixture }
      let(:results) { subject.perform(search_term) }
      let(:items) { results.keys }
      let(:search_term) { "Prelude to Foundation" }

      it "returns a hash with items as keys and availability as values" do
        expect(results.size).to be > 0
        results.each do |key, value|
          expect(key).to be_an(Item)
          expect(value).to be_an(Availability)
          expect(value.total_copies).to be_a(Numeric)
          expect(value.available_copies).to be_a(Numeric)
          expect(value.wait_list_size).to be_a(Numeric)
        end
      end

      it "returns expected results" do
        # These results where recorded by VCR at the time of writting this spec. They may change in the future
        expect(items.map(&:format)).to include("eBook", "Audiobook")
        expect(items.map(&:title)).to include(search_term)
        expect(items.map(&:author)).to include("Isaac Asimov")
      end
    end
  end
end
```

## Threading

A nice optimization on the library came after I had a working implementation in which each library was searched sequentially. Most of the time spent waiting for results is spent in network I/O. By using threads, we can start the search on each library at the same time and gather all results at the end. Ruby is (in)famous for having a Global Interpreter Lock which does not permit more than one Ruby thread from doing any work. However, that [does not apply to I/O operations][6], like communicating over the network.

The only threading portion of `franklin` looks like this:

``` ruby
module Franklin
  class ThreadedSearch
    attr_accessor :searchers

    def initialize(libraries)
      @searchers = libraries.map { |library| Search.new(library) }
    end

    def perform(search_terms)
      fail ArgumentError, "Please provide at least one search_term" if search_terms.empty?
      threads = searchers.map { |search| Thread.new { search.perform(search_terms) } }
      threads.join
      Collate.new.perform(threads.map(&:value))
    end
  end
end
```

Notice the `threads.join` that ensures that all threads have completed their work before continuing. Having the threading portion be as small as possible, makes the testing much simpler. See Mike Perham's [post on testing threading code][7] for a great take on that subject.

# Conclusion

I enjoyed working on `franklin` and have been using it often. Initially, I also thought that making this a CLI utility would introduce my kids to that world (they are 10 and 8). And it did. The interface is so simple:

``` text
$ franklin Prelude To Foundation
Searched for: Prelude To Foundation
======================================================
Prelude to Foundation
By Isaac Asimov
Format: eBook
Availability:
  Available @ San Francisco Public Library
  Available @ San Diego County Library
  4.0 people/copy @ Los Angeles County Library
======================================================
Prelude to Foundation
By Isaac Asimov
Format: Audiobook
Availability:
  Available @ San Francisco Public Library
  3.0 people/copy @ San Diego County Library
```

They tried it a few times on my computer and where keen to try it on the home computers too. However, it was then that I came upon RubyGem's problem as a utility-delivery mechanism: It works well for rubyists, but not for anyone else. Although OS X comes with a relatively modern ruby, it does not have a working development environment by default. `nokogiri` attempts to build native extensions upon installation, which blew up in my kid's computer because XCode was not installed. Coming in at over 4.4 GB, installing XCode was out of the question.

Hmm... Maybe I should look into `mruby` or `crystal-lang`...


[1]: /blog/categories/books
[2]: https://www.overdrive.com/
[3]: https://developer.overdrive.com/
[4]: http://codeartisan.blogspot.com/2012/07/using-html-as-media-type-for-your-api.html
[5]: https://rubygems.org/
[6]: http://ablogaboutcode.com/2012/02/06/the-ruby-global-interpreter-lock/
[7]: http://www.mikeperham.com/2015/12/14/how-to-test-multithreaded-code/
