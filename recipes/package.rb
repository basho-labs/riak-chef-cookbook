#
# Author:: Benjamin Black (<b@b3k.us>), Sean Cribbs (<sean@basho.com>),
# Seth Thomas (<sthomas@basho.com>), and Hector Castro (<hector@basho.com>)
# Cookbook Name:: riak Recipe:: package
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
if node['riak']['package']['local']['filename'].length > 0
  package_file = node['riak']['package']['local']['filename']

  unless node['riak']['package']['local']['url'].empty?
    package_uri = "#{node['riak']['package']['local']['url']}/#{package_file}"
    checksum_val = node['riak']['package']['local']['checksum']

    remote_file "#{Chef::Config[:file_cache_path]}/#{package_file}" do
      source package_uri
      checksum checksum_val
      owner 'root'
      mode 0644
    end
  end

  package node['riak']['package']['name'] do
    source "#{Chef::Config[:file_cache_path]}/#{package_file}"
    action :install
    options '--force-confdef --force-confold' if node['platform_family'] == 'debian'
    provider value_for_platform_family(
      ['debian'] => Chef::Provider::Package::Dpkg,
      %w(rhel fedora) => Chef::Provider::Package::Rpm
    )
    only_if do
      ::File.exist?("#{Chef::Config[:file_cache_path]}/#{package_file}") &&
        Digest::SHA256.file("#{Chef::Config[:file_cache_path]}/#{package_file}").hexdigest ==
        node['riak']['package']['local']['checksum']
    end
  end
else
  version_str = %w(major minor incremental).map { |ver| node['riak']['package']['version'][ver] }.join('.')
  platform_version = node['platform_version'].to_i
  package_version = "#{version_str}-#{node['riak']['package']['version']['build']}"

  case node['platform']
  when 'ubuntu', 'debian'
    packagecloud_repo 'basho/riak' do
      type 'deb'
    end

    package 'riak' do
      action :install
      version package_version
      options '-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"'
    end
  when 'centos', 'redhat', 'amazon', 'fedora'
    packagecloud_repo 'basho/riak' do
      type 'rpm'
    end

    case platform_version
    when 6, 2013, 2014
      package_version = "#{package_version}.el6"
    when 7
      package_version = "#{package_version}.el7.centos"
    when 19
      package_version = "#{package_version}.fc#{platform_version}"
    end

    package 'riak' do
      action :install
      version package_version
    end
  end
end
