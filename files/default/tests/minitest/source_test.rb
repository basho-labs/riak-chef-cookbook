require File.expand_path("../support/helpers", __FILE__)

describe "riak::source" do
  include Helpers::Riak

  it "installs riak" do
    file("#{node["riak"]["source"]["prefix"]}/riak").must_exist
  end
end
