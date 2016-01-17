require "oj"

module Oj
  class ArrayParser
    class ParserError < StandardError
    end

    def self.enumerator(string_or_io)
      Enumerator.new do |yielder|
        parser = new { |value| yielder << value }

        Oj.sc_parse(parser, string_or_io)
      end
    end

    def initialize(&block)
      @block = block
      @array_count = 0
    end

    def hash_start
      {}
    end

    def hash_set(hash, key, value)
      hash[key] = value
    end

    def array_start
      @array_count += 1

      if @array_count > 1
        []
      end
    end

    def array_end
      @array_count -= 1
    end

    def array_append(array, value)
      if @array_count == 1
        @block.call(value)
      else
        array << value
      end
    end

    def error(message, line, column)
      raise ParserError, "line: #{line}, column: #{column}, message: #{message}"
    end
  end
end
