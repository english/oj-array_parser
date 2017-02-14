require 'test_helper'
require 'oj/array_parser/specs'
require 'bigdecimal'
require 'pp'
require 'speculation'
require 'speculation/test'
require 'speculation/gen'
require 'rantly/minitest_extensions'

Speculation::Test.instrument

class Oj::ArrayParserTest < Minitest::Test
  S = Speculation

  using Speculation::NamespacedSymbols.refine(self)

  def test_that_it_has_a_version_number
    refute_nil ::Oj::ArrayParser::VERSION
  end

  def setup
    @json = <<-JSON
      [
        {
          "foo": ["bar"]
        },
        "baz",
        0.001
      ]
    JSON
  end

  def test_yields_values
    values = []

    parser = Oj::ArrayParser.new do |value|
      values << value
    end

    Oj.sc_parse(parser, @json)

    assert_equal 3, values.count

    assert_equal({ "foo" => [ "bar" ] }, values[0])
    assert_equal "baz", values[1]
    assert_equal 0.001, values[2]
  end

  def test_enumerator
    enumerator = Oj::ArrayParser.enumerator(@json)

    slices = enumerator.each_slice(2).to_a

    assert_equal 2, slices.count
    assert_equal 2, slices[0].count
    assert_equal 1, slices[1].count
  end

  def test_enumerator_options
    enumerator = Oj::ArrayParser.enumerator(@json)
    assert_equal Float, enumerator.to_a.last.class

    enumerator = Oj::ArrayParser.enumerator(@json, bigdecimal_load: :bigdecimal)
    assert_equal BigDecimal, enumerator.to_a.last.class
  end

  def test_check_enumerator
    results = Speculation::Test.check(Oj::ArrayParser.method(:enumerator))
    result = Speculation::Test.abbrev_result(results.first)

    assert_nil result[:failure], PP.pp(result, String.new)
  end

  def test_enumerator_doesnt_lose_anything
    gen = S.gen(S.coll_of(:any.ns(S)))

    property_of(&gen).check(1_000) { |coll|
      json = Oj.dump(coll)
      enumerator = Oj::ArrayParser.enumerator(json)

      assert_equal coll.count, enumerator.count
    }
  end
end
