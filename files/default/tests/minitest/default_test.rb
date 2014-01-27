require File.expand_path("../support/helpers", __FILE__)

describe "riak::default" do
  include Helpers::Riak

  it "installs riak" do
    if node["riak"]["install_method"] == "source"
      file("#{node["riak"]["source"]["prefix"]}/riak").must_exist
    else
      package(node["riak"]["package"]["enterprise_key"].empty? ? "riak" : "riak-ee").must_be_installed
    end
  end

  it "responds to riak ping" do
    assert(`riak ping` =~ /pong/) unless node["riak"]["install_method"] == "source"
  end

  it "emits riak stats" do
    unless node["riak"]["install_method"] == "source"
      ip, port = node["riak"]["config"]["listener"]["http"]["internal"].split(":")

      response = Net::HTTP.get_response(URI.parse("http://#{ip}:#{port}/stats"))
      assert(response.body =~ /sys_system_version/)
    end
  end
end
