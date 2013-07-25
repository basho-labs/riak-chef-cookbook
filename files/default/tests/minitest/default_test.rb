require File.expand_path("../support/helpers", __FILE__)

describe "riak::default" do
  include Helpers::Riak

  it "installs riak" do
    package(node["riak"]["package"]["enterprise_key"].empty? ? "riak" : "riak-ee").must_be_installed
  end

  it "responds to riak ping" do
    assert(`riak ping` =~ /pong/)
  end

  it "emits riak stats" do
    if node['riak']['config']['riak_kv']['riak_kv_stat']
      response = Net::HTTP.get_response(URI.parse("http://#{node['ipaddress']}:8098/stats"))
      assert(response.body =~ /sys_system_version/)
    else
      assert(true)
    end
  end
end
