# Oj::ArrayParser

Oj parser that yields values within a top level JSON array. This is useful when you can
read individual array items into memory, but not the whole array.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'oj-array_parser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oj-array_parser

## Usage

```ruby
json = <<JSON
[
  {
    'foo': ['bar']
  },
  'baz',
  'quux'
]
JSON

parser = Oj::ArrayParser.new do |value|
  puts value
end

Oj.sc_parse(parser, json)
# => { "foo" => ['bar'] }
# => 'baz'
# => 'quux'

# alternatively, build an enumerator of results

Oj::ArrayParser.enumerator(json).each_slice(2).each do |slice|
  puts slice
end
# => [{ "foo" => ['bar'] }, 'baz']
# => ['quux']
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/english/oj-array_parser.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

