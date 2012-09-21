# https://github.com/basho/erlang_template_helper/
# Copyright (c) 2012 Daniel Reverri
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module Eth
  module Erlang
    module String
      def to_erl_string
        "__string_#{self}"
      end

      def to_erl_binary
        "__binary_#{self}"
      end
    end

    module Array
      def to_erl_tuple
        ["__tuple"] + self
      end

      def to_erl_list
        ["__list"] + self
      end
    end
  end

  module InstanceMethods
    def convert(value)
      case value
      when ::String
        Eth::String.new(value)
      when ::Array
        Eth::Array.new(value)
      when ::Hash
        Eth::Hash.new(value)
      when ::TrueClass
        Eth::Value.new("true")
      when ::FalseClass
        Eth::Value.new("false")
      when ::NilClass
        Eth::Value.new("null")
      else
        Eth::Value.new(value)
      end
    end

    def indent(level)
      "\t" * level
    end
  end

  class Value
    def initialize(val)
      @val = val
    end

    def to_s
      @val
    end

    def pp(level=0)
      to_s
    end
  end

  class String
    def initialize(str)
      @str = str
    end

    def to_s
      case @str
      when /^__binary_(.*)/
        to_binary($1)
      when /^__string_(.*)/
        to_string($1)
      when /^__atom_(.*)/
        to_atom($1)
      else
        to_atom(@str)
      end
    end

    def pp(level=0)
      to_s
    end

    private

    def to_binary(str)
      "<<\"#{str}\">>"
    end

    def to_string(str)
      "\"#{str}\""
    end

    def to_atom(str)
      case str
      when /^[a-z][\w@]*$/
        str
      else
        "'#{str}'"
      end
    end
  end

  class Array
    include InstanceMethods

    def initialize(arr)
      case arr[0]
      when "__list"
        @type = :list
        @values = arr[1..-1].map { |e| convert(e) }
      when "__tuple"
        @type = :tuple
        @values = arr[1..-1].map { |e| convert(e) }
      else
        @type = :list
        @values = arr.map { |e| convert(e) }
      end
    end

    def to_s
      values1 = @values.map { |v| v.to_s }
      case @type
      when :tuple
        "{#{values1.join(", ")}}"
      else
        "[#{values1.join(", ")}]"
      end
    end

    def pp(level=0)
      case @type
      when :tuple
        values1 = @values.map { |v| v.pp(level+1) }
        "{#{values1.join(", ")}}"
      else
        values1 = @values.map { |v| "\n#{indent(level+1)}#{v.pp(level+1)}" }
        "[#{values1.join(",")}\n#{indent(level)}]"
      end
    end
  end

  class Hash
    include InstanceMethods

    def initialize(hsh)
      @data = []
      hsh.sort.map do |k,v|
        k1 = Eth::String.new(k.to_s)
        v1 = convert(v)
        @data << [k1, v1]
      end
    end

    def to_s
      values = @data.map do |k,v|
        "{#{k.to_s}, #{v.to_s}}"
      end
      "[#{values.join(", ")}]"
    end

    def pp(level=0)
      values = @data.map do |k,v|
        "\n#{indent(level+1)}{#{k.to_s}, #{v.pp(level+1)}}"
      end
      "[#{values.join(",")}\n#{indent(level)}]"
    end
  end

  class Config
    include InstanceMethods

    def initialize(value)
      @config = convert(value)
    end

    def to_s
      @config.to_s + "."
    end

    def pp(level=0)
      @config.pp(level) + "."
    end
  end

  class Args
    def initialize(args)
      @args = args
    end

    def expand(k1, v1)
      case v1
      when ::Hash
        v1.sort.map { |k2, v2| expand("#{k1} #{k2}", v2) }
      else
        "#{k1} #{v1}"
      end
    end

    def to_a
      @args.sort.map { |k, v| expand(k, v) }.flatten
    end

    def to_s
      to_a.join(" ")
    end

    def pp(level=0)
      to_a.join("\n")
    end
  end
end
