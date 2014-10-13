require "spec_helper"

describe file("/opt/riak") do
  it { should be_directory }
end

describe file("/opt/riak/etc/app.config") do
  it { should be_file }
end

describe file("/opt/riak/etc/vm.args") do
  it { should be_file }
end