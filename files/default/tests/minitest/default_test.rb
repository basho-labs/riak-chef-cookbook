require File.expand_path("../support/helpers", __FILE__)

describe "riak::default" do
  include Helpers::Riak

  it "installs riak" do
    package("riak").must_be_installed
  end

  it "runs a service named riak" do
    service("riak").must_be_running
  end

  it "responds to riak ping" do
    assert(`riak ping` =~ /pong/)
  end
end
