require "spec_helper"

describe file("/opt/riak") do
  it { should be_directory }
end

describe file("/opt/riak/etc/riak.conf") do
  it { should be_file }
end