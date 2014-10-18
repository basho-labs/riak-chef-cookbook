require 'spec_helper'

describe package('riak') do
  it { should be_installed }
end

describe service('riak') do
  it { should be_enabled }
  it { should be_running }
end

describe port(8098) do
  it { should be_listening }
end

describe port(8087) do
  it { should be_listening }
end

describe file('/etc/riak/riak.conf') do
  it { should be_file }
end

if ['debian', 'ubuntu'].include?(os[:family])
  describe command('/etc/init.d/riak ping') do
    its(:stdout) { should eq "pong\n" }
  end
else
  describe command('riak ping') do
    its(:stdout) { should eq "pong\n" }
  end
end