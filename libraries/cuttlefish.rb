module Cuttlefish
  def self.compile(prefix, config)
    case config
    when Array
      "#{prefix} = #{config.join(' ')}"
    when String, Fixnum, Bignum, Float, Symbol
      "#{prefix} = #{config}"
    when Hash, Chef::Node::Attribute
      prefix = "#{prefix}." unless prefix.empty?
      config.map { |k, v| compile("#{prefix}#{k.chomp('.top_level')}", v) }.flatten
    else
      fail Chef::Exceptions::UnsupportedAction, "Riak cookbook can't handle values of type: #{config.class}"
    end
  end
end
