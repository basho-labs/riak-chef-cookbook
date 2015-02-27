require 'spec_helper'

describe package('riak-ee') do
  it 'is installed' do
    expect(subject).to be_installed
  end
end

describe service('riak') do
  it 'is enabled' do
    expect(subject).to be_enabled
  end

  it 'is running' do
    expect(subject).to be_running
  end
end

describe port(8098) do
  it 'is listening' do
    expect(subject).to be_listening
  end
end

describe port(8087) do
  it 'is listening' do
    expect(subject).to be_listening
  end
end

if %w(freebsd).include?(os[:family])
  describe file('/usr/local/etc/riak/riak.conf') do
    it 'is a file' do
      expect(subject).to be_file
    end
  end
else
  describe file('/etc/riak/riak.conf') do
    it 'is a file' do
      expect(subject).to be_file
    end
  end
end

if %w(debian ubuntu).include?(os[:family])
  describe command('/etc/init.d/riak ping') do
    its(:stdout) { is_expected.to eq "pong\n" }
  end
else
  describe command('riak ping') do
    its(:stdout) { is_expected.to eq "pong\n" }
  end
end
