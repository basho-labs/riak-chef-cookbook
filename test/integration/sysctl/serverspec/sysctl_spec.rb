require 'spec_helper'

describe file('/proc/sys/vm/swappiness') do
  it { should be_file }
  it { should contain '0' }
end

describe file('/proc/sys/net/core/somaxconn') do
  it { should be_file }
  it { should contain '40000' }
end

describe file('/proc/sys/net/core/wmem_default') do
  it { should be_file }
  it { should contain '8388608' }
end

describe file('/proc/sys/net/core/wmem_max') do
  it { should be_file }
  it { should contain '8388608' }
end

describe file('/proc/sys/net/core/rmem_default') do
  it { should be_file }
  it { should contain '8388608' }
end

describe file('/proc/sys/net/core/rmem_max') do
  it { should be_file }
  it { should contain '8388608' }
end

describe file('/proc/sys/net/core/netdev_max_backlog') do
  it { should be_file }
  it { should contain '10000' }
end

describe file('/proc/sys/net/ipv4/tcp_max_syn_backlog') do
  it { should be_file }
  it { should contain '40000' }
end

describe file('/proc/sys/net/ipv4/tcp_sack') do
  it { should be_file }
  it { should contain '1' }
end

describe file('/proc/sys/net/ipv4/tcp_window_scaling') do
  it { should be_file }
  it { should contain '1' }
end

describe file('/proc/sys/net/ipv4/tcp_fin_timeout') do
  it { should be_file }
  it { should contain '15' }
end

describe file('/proc/sys/net/ipv4/tcp_keepalive_intvl') do
  it { should be_file }
  it { should contain '30' }
end

describe file('/proc/sys/net/ipv4/tcp_tw_reuse') do
  it { should be_file }
  it { should contain '1' }
end

describe file('/proc/sys/net/ipv4/tcp_moderate_rcvbuf') do
  it { should be_file }
  it { should contain '1' }
end

persistence_file = case host_inventory['platform']
                   when 'redhat', 'fedora', 'amazon','debian', 'ubuntu'
                     '/etc/sysctl.d/99-chef-attributes.conf'
                   else
                     '/etc/sysctl.conf'
                   end

describe file(persistence_file) do
  it { should be_file }
  it { should contain 'vm.swappiness=0' }
  it { should contain 'net.core.somaxconn=40000' }
  it { should contain 'net.core.wmem_default=8388608' }
  it { should contain 'net.core.wmem_max=8388608' }
  it { should contain 'net.core.rmem_default=8388608' }
  it { should contain 'net.core.rmem_max=8388608' }
  it { should contain 'net.core.netdev_max_backlog=10000' }
  it { should contain 'net.ipv4.tcp_max_syn_backlog=40000' }
  it { should contain 'net.ipv4.tcp_sack=1' }
  it { should contain 'net.ipv4.tcp_window_scaling=1' }
  it { should contain 'net.ipv4.tcp_fin_timeout=15' }
  it { should contain 'net.ipv4.tcp_keepalive_intvl=30' }
  it { should contain 'net.ipv4.tcp_tw_reuse=1' }
  it { should contain 'net.ipv4.tcp_moderate_rcvbuf=1' }
end
