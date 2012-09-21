#
# Author:: Benjamin Black (<b@b3k.us>) and Sean Cribbs (<sean@basho.com>)
# Cookbook Name:: riak
# Recipe:: default
#
# Copyright (c) 2012 Basho Technologies, Inc.
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

version_str = "#{node['riak']['package']['version']['major']}.#{node['riak']['package']['version']['minor']}"
base_uri = "http://s3.amazonaws.com/downloads.basho.com/riak/#{version_str}/#{version_str}.#{node['riak']['package']['version']['incremental']}/"
base_filename = "riak-#{version_str}.#{node['riak']['package']['version']['incremental']}"

case node['riak']['package']['type']
  when "binary"
    case node['platform']
    when "ubuntu"
      machines = {"x86_64" => "amd64", "i386" => "i386", "i686" => "i386"}
      base_uri = "#{base_uri}#{node['platform']}/#{node['lsb']['codename']}/"
      package "libssl0.9.8"
      package_file = "#{base_filename.gsub(/\-/, '_')}-#{node['riak']['package']['version']['build']}_#{machines[node['kernel']['machine']]}.deb"
    when "debian"
      machines = {"x86_64" => "amd64", "i386" => "i386", "i686" => "i386"}
      base_uri = "#{base_uri}#{node['platform']}/squeeze/"
      package_file = "#{base_filename.gsub(/\-/, '_').sub(/_/,'-')}-#{node['riak']['package']['version']['build']}_#{machines[node['kernel']['machine']]}.deb"
    when "redhat","centos"
      machines = {"x86_64" => "x86_64", "i386" => "i386", "i686" => "i686"}
      base_uri = "#{base_uri}rhel/#{node['platform_version'].to_i}/"
      package_file = "#{base_filename}-#{node['riak']['package']['version']['build']}.el#{node['platform_version'].to_i}.#{machines[node['kernel']['machine']]}.rpm"
      node['riak']['config']['riak_core']['platform_lib_dir'] = "/usr/lib64/riak".to_erl_string if node['kernel']['machine'] == 'x86_64'
    when "fedora"
      machines = {"x86_64" => "x86_64", "i386" => "i386", "i686" => "i686"}
      base_uri = "#{base_uri}#{node['platform']}/#{node['platform_version'].to_i}/"
      package_file = "#{base_filename}-#{node['riak']['package']['version']['build']}.fc#{node['platform_version'].to_i}.#{node['kernel']['machine']}.rpm"
      node['riak']['config']['riak_core']['platform_lib_dir'] = "/usr/lib64/riak".to_erl_string if node['kernel']['machine'] == 'x86_64'
    end
  when "source"
    package_file = "#{base_filename.sub(/\-/, '_')}.tar.gz"
    node['riak']['package']['prefix'] = "/usr/local"
    node['riak']['package']['config_dir'] = node['riak_eds']['package']['prefix'] + "/riak/etc"
  end

package_uri = base_uri + package_file

package_name = package_file.split("[-_]\d+\.").first

group "riak"

user "riak" do
  gid "riak"
  shell "/bin/bash"
  home "/var/lib/riak"
  system true
end

remote_file "#{Chef::Config[:file_cache_path]}/#{package_file}" do
  source package_uri
  owner "root"
  mode 0644
  checksum node['riak']['package']['source_checksum']
  not_if { File.exists?("#{Chef::Config[:file_cache_path]}/#{package_file}") }
end

case node['riak']['package']['type']
when "binary"
  package package_name do
    source "#{Chef::Config[:file_cache_path]}/#{package_file}"
    action :install
    options case node['platform']
            when "debian","ubuntu"
              "--force-confdef --force-confold"
            end       
    provider value_for_platform(
      [ "ubuntu", "debian" ] => {"default" => Chef::Provider::Package::Dpkg},
      [ "redhat", "centos", "fedora" ] => {"default" => Chef::Provider::Package::Rpm}
    )
  end
when "source"
  execute "riak-src-unpack" do
    cwd Chef::Config[:file_cache_path]
    command "tar xvfz #{package_file}"
  end

  execute "riak-src-build" do
    cwd "#{Chef::Config[:file_cache_path]}/#{base_filename}"
    command "make clean all rel"
  end

  execute "riak-src-install" do
    command "mv #{Chef::Config[:file_cache_path]}/#{base_filename}/rel/riak #{node['riak']['package']['prefix']}"
    not_if { File.directory?("#{node['riak']['package']['prefix']}/riak") }
  end
end

directory node['riak']['package']['config_dir'] do
  owner "root"
  mode "0755"
  action :create
end

file "#{node['riak']['package']['config_dir']}/app.config" do
  content Eth::Config.new(node['riak']['config'].to_hash).pp
  owner "root"
  mode 0644
end

file "#{node['riak']['package']['config_dir']}/vm.args" do
  content Eth::Args.new(node['riak']['args'].to_hash).pp
  owner "root"
  mode 0644
end

service "riak" do
  supports :start => true, :stop => true, :restart => true
  action [ :enable ]
  subscribes :restart, resources(:file => [ "#{node['riak']['package']['config_dir']}/app.config",
                                   "#{node['riak']['package']['config_dir']}/vm.args" ])
  only_if { node['riak']['package']['type'] == "binary" }
end
