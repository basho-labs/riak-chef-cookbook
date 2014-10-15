require "spec_helper"

describe package("riak-ee") do
  it { should be_installed }
end

describe service("riak") do
  it { should be_enabled }
  it { should be_running }
end

describe port(8098) do
  it { should be_listening }
end

describe port(8087) do
  it { should be_listening }
end

describe file("/etc/riak/app.config") do
  it { should be_file }
end

describe file("/etc/riak/vm.args") do
  it { should be_file }
end

describe command("riak ping") do
  its(:stdout) { should eq "pong\n" }
end
