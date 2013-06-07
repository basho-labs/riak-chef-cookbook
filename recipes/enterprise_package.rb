#
# Author:: Benjamin Black (<b@b3k.us>) and Sean Cribbs (<sean@basho.com>) and Seth Thomas (<sthomas@basho.com>)
# Cookbook Name:: riak
# Recipe:: enterprise_package
#
# Copyright (c) 2013 Basho Technologies, Inc.
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

version_str = "#{node['riak']['package']['version']['major']}.#{node['riak']['package']['version']['minor']}.#{node['riak']['package']['version']['incremental']}"
base_uri = "http://private.downloads.basho.com/riak_ee/#{node['riak']['package']['enterprise_key']}/#{version_str}/"
base_filename = "riak-ee-#{version_str}"

case node['platform']
when "ubuntu"
  machines = {"x86_64" => "amd64", "i386" => "i386", "i686" => "i386"}
  #checksum_val = node['riak']['package']['checksum']['ubuntu'][node['lsb']['codename']][node['kernel']['machine']]
  base_uri = "#{base_uri}#{node['platform']}/#{node['lsb']['codename']}/"
  package "libssl0.9.8" 
  package_file = "#{base_filename.gsub(/\-/, '_').sub(/_/,'-')}-#{node['riak']['package']['version']['build']}_#{machines[node['kernel']['machine']]}.deb" 
when "debian"
  machines = {"x86_64" => "amd64", "i386" => "i386", "i686" => "i386"}
  #checksum_val = node['riak']['package']['checksum']['debian'][node['platform_version']]
  base_uri = "#{base_uri}#{node['platform']}/squeeze/"
  package_file = "#{base_filename.gsub(/\-/, '_').sub(/_/,'-')}-#{node['riak']['package']['version']['build']}_#{machines[node['kernel']['machine']]}.deb"
when "redhat","centos"
  machines = {"x86_64" => "x86_64", "i386" => "i386", "i686" => "i686"}
  #checksum_val = node['riak']['package']['checksum']['rhel'][node['platform_version']]
  base_uri = "#{base_uri}rhel/#{node['platform_version'].to_i}/"
  package_file = "#{base_filename}-#{node['riak']['package']['version']['build']}.el#{node['platform_version'].to_i}.#{machines[node['kernel']['machine']]}.rpm"
  node.set['riak']['config']['riak_core']['platform_lib_dir'] = "/usr/lib64/riak".to_erl_string if node['kernel']['machine'] == 'x86_64'
when "fedora"
  machines = {"x86_64" => "x86_64", "i386" => "i386", "i686" => "i686"}
  #checksum_val = node['riak']['package']['checksum']['fedora'][node['platform_version']]
  base_uri = "#{base_uri}#{node['platform']}/#{node['platform_version'].to_i}/"
  package_file = "#{base_filename}-#{node['riak']['package']['version']['build']}.fc#{node['platform_version'].to_i}.#{node['kernel']['machine']}.rpm"
  node.set['riak']['config']['riak_core']['platform_lib_dir'] = "/usr/lib64/riak".to_erl_string if node['kernel']['machine'] == 'x86_64'
end

package_uri = base_uri + package_file
package_name = package_file.split("[-_]\d+\.").first

if node['riak']['package']['local_package'] == false
  remote_file "#{Chef::Config[:file_cache_path]}/#{package_file}" do
    source package_uri
    owner "root"
    mode 0644
    not_if(File.exists?("#{Chef::Config[:file_cache_path]}/#{package_file}") && Digest::SHA256.file("#{Chef::Config[:file_cache_path]}/#{package_file}").hexdigest == node['riak']['package']['checksum']['local'])
  end
else
  package_file = node['riak']['package']['local_package']

  cookbook_file "#{Chef::Config[:file_cache_path]}/#{package_file}" do
    source package_file
    owner "root"
    mode 0644
    not_if(File.exists?("#{Chef::Config[:file_cache_path]}/#{package_file}") && Digest::SHA256.file("#{Chef::Config[:file_cache_path]}/#{package_file}").hexdigest == checksum_val)
  end
end

package package_name do
  source "#{Chef::Config[:file_cache_path]}/#{package_file}"
  action :install
  case node['platform'] when "ubuntu","debian"
    options "--force-confdef --force-confold"
  end
  provider value_for_platform(
    [ "ubuntu", "debian" ] => {"default" => Chef::Provider::Package::Dpkg},
    [ "redhat", "centos", "fedora" ] => {"default" => Chef::Provider::Package::Yum}
  )
end
