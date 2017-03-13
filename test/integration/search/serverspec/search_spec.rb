require 'spec_helper'

describe package('riak') do
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

describe command('java -version') do
  its(:stderr) { is_expected.to match(/java version "1.8.0_121"/) }
end

describe process('java') do
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

describe port(8093) do
  it 'is listening' do
    expect(subject).to be_listening
  end
end

describe port(8985) do
  it 'is listening' do
    expect(subject).to be_listening
  end
end

describe file('/etc/riak/riak.conf') do
  it 'is a file' do
    expect(subject).to be_file
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
