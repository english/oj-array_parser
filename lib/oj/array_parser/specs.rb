require 'speculation'
require 'oj'
require 'oj/array_parser'

module Oj
  class ArrayParser
    module Specs
      S = Speculation
      using Speculation::NamespacedSymbols.refine(self)

      S.def(:string_to_json.ns,
            S.conformer(->(string) { Oj.load(string) rescue :invalid.ns(Speculation) }))

      S.def(:io_to_string.ns, S.conformer(->(io) { io.read.tap { io.rewind } }))

      json_string_gen = ->(rantly) {
        coll_gen = S.gen(S.coll_of(:any.ns(S)))
        coll = coll_gen.call(rantly)
        Oj.dump(coll)
      }
      S.def(:json_string.ns, S.with_gen(S.and(String, :string_to_json.ns, Array), &json_string_gen))

      S.def(:io.ns, ->(x) { x.respond_to?(:read) })
      json_io_gen = ->(rantly) {
        gen = S.gen(:json_string.ns)
        json = gen.call(rantly)
        StringIO.new(json)
      }
      S.def(:json_io.ns, S.with_gen(S.and(:io.ns, :io_to_string.ns, :json_string.ns, Array), &json_io_gen))

      S.def(:enumerator_opts.ns, S.zero_or_one(S.hash_of(Symbol, :any.ns(S))))

      S.fdef(Oj::ArrayParser.method(:enumerator),
             :args => S.cat(:string_or_io => S.or(:string => :json_string.ns, :io => :json_io.ns),
                            :options => :enumerator_opts.ns),
             :ret => Enumerator)
    end
  end
end
