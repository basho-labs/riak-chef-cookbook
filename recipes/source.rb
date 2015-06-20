#
# Author:: Seth Thomas (<sthomas@basho.com>) and Hector Castro (<hector@basho.com>)
# Cookbook Name:: riak
# Recipe:: source
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
node.default['erlang']['source']['version'] = 'R16B02-basho5'
node.default['erlang']['source']['url'] = "http://s3.amazonaws.com/downloads.basho.com/erlang/otp_src_#{node['erlang']['source']['version']}.tar.gz"
node.default['erlang']['source']['checksum'] = '5c36ed749f0f56d003d28ab352fa7cb405f11dbbfb885370edb69d3c1bd321fb'
node.default['erlang']['source']['build_flags'] = '--disable-hipe --enable-smp-support --without-odbc --enable-m64-build'

if node['platform_family'] == 'rhel' && node['platform_version'].to_f >= 6.5
  node.default['erlang']['source']['cflags'] = '-DOPENSSL_NO_EC=1'
end

node.default['riak']['platform_bin_dir'] = "#{node['riak']['source']['prefix']}/riak/bin"
node.default['riak']['platform_etc_dir'] = "#{node['riak']['source']['prefix']}/riak/etc"
node.default['riak']['platform_data_dir'] = "#{node['riak']['source']['prefix']}/riak/data"
node.default['riak']['platform_log_dir'] = "#{node['riak']['source']['prefix']}/riak/log"
node.default['riak']['platform_lib_dir'] = "#{node['riak']['source']['prefix']}/riak/lib"

node.default['riak']['config']['log']['console']['file'] = "#{node['riak']['platform_log_dir']}/console.log"
node.default['riak']['config']['log']['error']['file'] = "#{node['riak']['platform_log_dir']}/error.log"
node.default['riak']['config']['log']['crash']['file'] = "#{node['riak']['platform_log_dir']}/crash.log"
node.default['riak']['config']['ring']['state_dir'] = "#{node['riak']['platform_data_dir']}/ring"
node.default['riak']['config']['bitcask']['data_root'] = "#{node['riak']['platform_data_dir']}/bitcask"
node.default['riak']['config']['leveldb']['data_root'] = "#{node['riak']['platform_data_dir']}/leveldb"
node.default['riak']['config']['search']['anti_entropy']['data_dir'] = "#{node['riak']['platform_data_dir']}/yz_anti_entropy"
node.default['riak']['config']['search']['root_dir'] = "#{node['riak']['platform_data_dir']}/yz"

include_recipe 'git'
include_recipe 'build-essential'
include_recipe 'erlang::source'

pam_packages = value_for_platform_family(
  %w(debian ubuntu)  => ['libpam0g-dev', 'libssl-dev'],
  %w(rhel fedora)  => ['pam-devel', 'openssl-devel']
)

pam_packages.each do |pam_package|
  package pam_package do
    action :install
  end
end

source_version = "#{node['riak']['source']['version']['major']}.#{node['riak']['source']['version']['minor']}"
source_uri = "#{node['riak']['source']['url']}/#{source_version}/#{source_version}.#{node['riak']['source']['version']['incremental']}/"
source_file = "riak-#{source_version}.#{node['riak']['source']['version']['incremental']}"
source_filename = "#{source_file}.tar.gz"

group 'riak' do
  system true
end

user 'riak' do
  gid 'riak'
  shell '/bin/bash'
  home node['riak']['platform_data_dir']
  system true
end

remote_file "#{Chef::Config[:file_cache_path]}/#{source_filename}" do
  source source_uri + source_filename
  owner 'root'
  mode 0644

  not_if do
    ::File.exist?("#{Chef::Config[:file_cache_path]}/#{source_filename}") &&
      Digest::SHA256.file("#{Chef::Config[:file_cache_path]}/#{source_filename}").hexdigest == node['riak']['source']['checksum']
  end
end

execute 'riak-src-unpack' do
  cwd Chef::Config[:file_cache_path]
  command "tar xfz #{source_filename}"
  not_if { File.directory?(File.join(Chef::Config[:file_cache_path], source_file)) }
end

execute 'riak-src-build' do
  cwd "#{Chef::Config[:file_cache_path]}/#{source_file}"
  command 'make clean locked-deps all rel'
  not_if { File.directory?("#{node['riak']['source']['prefix']}/riak") }
end

execute 'riak-src-install' do
  command "mv #{Chef::Config[:file_cache_path]}/#{source_file}/rel/riak #{node['riak']['source']['prefix']}"
  not_if { File.directory?("#{node['riak']['source']['prefix']}/riak") }
end
