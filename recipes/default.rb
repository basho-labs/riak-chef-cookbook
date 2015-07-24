#
# Author:: Seth Thomas (<sthomas@basho.com>) and Hector Castro (<hector@basho.com>)
# Cookbook Name:: riak
# Recipe:: default
#
# Copyright (c) 2014 Basho Technologies, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'riak::java' if node['riak']['manage_java']

# validate the fqdn and if probalo then use IP address
valid_fqdn_regexp = /(?=^.{4,255}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}$)/

unless valid_fqdn_regexp.match(node['fqdn'])
  node.default['riak']['config']['nodename'] = "riak@#{node['ipaddress']}"
end

riak_service = node['platform'] == 'fedora' ? 'riak.service' : 'riak'

case node['platform_family']
when 'debian'
  file '/etc/default/riak' do
    content "ulimit -n #{node['riak']['limits']['nofile']}"
    owner 'root'
    mode 0644
    action :create
  end
when 'rhel'
  include_recipe 'ulimit'

  user_ulimit 'riak' do
    filehandle_limit node['riak']['limits']['nofile']
  end
when 'freebsd'
  case node['platform_version'].to_i
  when 10
    package 'lang/gcc'
    execute 'pkg upgrade -y'
  when 9
    include_recipe 'pkg_add'

    directory '/usr/local/etc/rc.d' do
      mode 0755
      action :create
    end
    template '/usr/local/etc/rc.d/riak' do
      source 'rcd.erb'
      mode  0755
      action :create
    end
  end
end

if node['riak']['install_method'] == 'source'
  include_recipe 'riak::source'
else
  include_recipe 'riak::package'
end

file "#{node['riak']['platform_etc_dir']}/riak.conf" do
  content lazy { Cuttlefish.compile('', node['riak']['config']).join("\n") }
  owner 'root'
  mode 0644
  notifies :restart, "service[#{riak_service}]"
end

node['riak']['patches'].each do |patch|
  cookbook_file "#{node['riak']['platform_lib_dir']}/basho-patches/#{patch}" do
    source patch
    owner 'root'
    mode 0644
    notifies :restart, "service[#{riak_service}]"
  end
end

directory node['riak']['platform_data_dir'] do
  owner 'riak'
  group 'riak'
  mode 0755
  action :create
end

directory ::File.join(node['riak']['platform_data_dir'], 'snmp', 'agent', 'db') do
  owner 'riak'
  group 'riak'
  mode 0755
  action :create
  recursive true
  not_if { node['riak']['package']['enterprise_key'].empty? }
end

service riak_service do
  supports start: true, stop: true, restart: true, status: true
  action [:enable, :start]
  not_if { node['riak']['install_method'] == 'source' }
end
