#
# Author:: Seth Thomas (<sthomas@basho.com>)
# Cookbook Name:: riak
# Recipe:: default
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
include_recipe "ulimit"

if node['riak']['package']['enterprise_key'].empty?
  include_recipe "riak::package"
else
  include_recipe "riak::enterprise_package"
end

file "#{node['riak']['package']['config_dir']}/app.config" do
  content Eth::Config.new(node['riak']['config'].to_hash).pp
  owner "root"
  mode 0644
  notifies :restart, "service[riak]"
end

file "#{node['riak']['package']['config_dir']}/vm.args" do
  content Eth::Args.new(node['riak']['args'].to_hash).pp
  owner "root"
  mode 0644
  notifies :restart, "service[riak]"
end

user_ulimit "riak" do
  filehandle_limit node['riak']['limits']['nofile']
end

node['riak']['patches'].each do |patch|
  cookbook_file "#{node['riak']['config']['riak_core']['platform_lib_dir'].gsub(/__string_/,'')}/lib/basho-patches/#{patch}" do
    source patch
    owner "root"
    mode 0644
    checksum
    notifies :restart, "service[riak]"
  end
end

service "riak" do
  supports :start => true, :stop => true, :restart => true
  action [ :enable, :start ]
end
