#
# Author:: Hector Castro (<hector@basho.com>)
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
version_str = %w(major minor incremental).map { |ver| node['riak']['package']['version'][ver] }.join('.')
package_version = "#{version_str}-#{node['riak']['package']['version']['build']}"
platform_version = node['platform_version'].to_i

if node['platform_family'] == 'rhel' && platform_version >= 6
  package_version = "#{package_version}.el#{platform_version}"
elsif node['platform_family'] == 'fedora'
  package_version = "#{package_version}.fc#{platform_version}"
end

package node['riak']['package']['name'] do
  action :install
  version package_version
end
