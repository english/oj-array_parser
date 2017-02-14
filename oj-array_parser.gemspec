# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oj/array_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "oj-array_parser"
  spec.version       = Oj::ArrayParser::VERSION
  spec.authors       = ["Jamie English"]
  spec.email         = ["jamienglish@gmail.com"]

  spec.summary       = %q{Oj parser that yields values within a top level JSON array.}
  spec.homepage      = "https://github.com/english/oj-array_parser"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "oj", "~> 2.14"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.8"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "speculation", "~> 0.1"
end
