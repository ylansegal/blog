---
layout: post
title: "RSpec DSL Is Just Fine"
date: 2022-07-06 11:51:00 -0700
categories:
- ruby
- rspec
excerpt_separator: <!-- more -->
---

In a [recent article][article], Caleb Hearth proposes improving RSpec specifications by using ruby methods. I don't agree with his prescription.

The original motivation for the article is to avoid the [Mystert Guest][mystery] problem. I agree with the intention: Having clear and legible specs is a great goal and is an integral part of a maintainable system.

Let's examine the author's spec, after it has been refactored to his liking, and using standard Ruby's method for setup. I copy and pasted the code from the original article at the time of writing:

<!-- more -->

{% highlight ruby linenos %}
RSpec.describe PlayerCharacter do
  context "rogue" do
    it "has sneak attack" do
      expect(rogue).to have_sneak_attack
    end

    context "at level 6" do
      it "has expertise" do
        expect(rogue).to have_expertise
      end

      def rogue
        super.tap do |r|
          5.times { r.add_level(:rogue) }
        end
      end
    end

    def rogue
      pc(:rogue)
    end
  end

  # (snip specs for other classes...)

  def pc(*levels)
    pc = PlayerCharacter.new
    levels.each { |l| pc.add_level(l) }
    pc
  end
end
{% endhighlight %}

There are things that bother me about this example. The first is the mix between RSpec's DSL (e.g. `describe`, `context`) and standard ruby (e.g. `def ...`). I think this adds a burden to the reader to keep top-of-mind that RSpec defines anonymous classes. In fact, the author explains this in the second paragraph of the article.

My second objection is that this code example doesn't accomplish what it set out to do: Remove the mystery guest!. Moreover, it actually moves the setup of the test far away from the test itself.

There are two assertion in this file. The one on line 4, and the one on line 9. To figure out how `rogue` is defined in line 4, I have to scroll to line 19 and see the method definition. Now, that depends on `pc`, which in turn is defined in line 26 (which by the author's own admission would be actually farther away, since more specs were snipped).

The second assertion is even worse. To know how `rogue` comes from in line 9, I first have to visit the definition on line 12, which in turn calls `super`. that takes me back to line 19, and then to 26. Even worse, the definition of `rogue` on line 12 has a mystery guest of it's own: The `5` in line 14. Where does that come from? The context for the spec calls for "at level 6". Is the `5` an error? It's not clear until we trace the fact that `super` has produced a `rogue` already at level `1`, and we need to add `5` more to get to `6`.

Now, I am not arguing that using RSpec DSL means that your specs are always going to be crystal clear. I argue that it's quite possible to create legible specs with the DSL. Here is the same spec, as I would write it:

{% highlight ruby linenos %}
RSpec.describe PlayerCharacter do
  context "rogue" do
    subject { PlayerCharacter.new.tap { |pc| pc.add_level(:rouge) } }

    it "has sneak attack" do
      expect(subject).to have_sneak_attack
    end

    context "at level 6" do
      let(:level) { 6 }
      subject { PlayerCharacter.new.tap { |pc| level.times { pc.add_level(:rouge) } } }

      it "has expertise" do
        expect(subject).to have_expertise
      end
    end
  end
end
{% endhighlight %}

The rewritten spec is readable from top to bottom. The `subject` is introduced close to each context. In particular, I would point the reader to the "at level 6" context. The very next line, introduces a `level` that is hard-coded at 6. It should be painly clear where that comes from, and that it's particularly relevant to this context. The next line will use it to setup the `subject`.

Another argument made in the original article is that:

> But let is not Ruby, and using it is an unnecessary abstraction.

I don't quite follow why the line is drawn at `let`. The author seems quite happy to use other RSpec abstractions like `have_sneak_attack` and `have_expertise`. Since there is no mention of custom matchers, I assume that it is reliant on RSpec [built-in predicate matchers][matchers]. A spec in the form of `have_xxx` passes when the subject's `have_xxx?` method returns true. I personally find that abstraction much harder to internalize than a `let` or `subject` declaration.

The author also mentions that using ruby methods makes existing tooling work better. While it's true that _my_ tooling doesn't understand `let` and `subject` declarations, I don't see how having nested methods calling `super` on each other improves the situation. When trying to jump to the definition, my tooling would show me all possible definitions. I would still have to choose which one to jump to. How would I know which one is the correct one? Even if I did, the `super` means that they would need to jump to all of them anyway.

## Conclusion

I believe that the code presented as an example of a good spec by the author can be much improved by using RSpec existing DSL. The example is clearly not as complex as specs in most production code bases, but I stock to it because that is what the author used.

In practice, I've seen many specs that stick to RSpec's DSL and are very hard to follow, have mystery guests, and are generally painful to use. I don't blame the DSL or think that using methods would immediately improve the situation. Clear, legible specs are possible if they are written intentionally. Collaborators should be defined close to where they are used. Clarity beats brevity. Some repetition in test setup is fine. RSpec DSL is fine, too.

[article]: https://blog.testdouble.com/posts/2022-06-29-define-methods-in-rspec/
[mystery]: http://xunitpatterns.com/Obscure%20Test.html#Mystery%20Guest
[matchers]: https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers