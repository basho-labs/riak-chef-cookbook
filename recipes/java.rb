#
# Author:: Seth Thomas (<sthomas@chef.io>)
# Cookbook Name:: riak
# Recipe:: java
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

node.default['java']['install_flavor'] = 'oracle'
node.default['java']['jdk_version'] = 7
node.default['java']['jdk']['7']['x86_64']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/7u25-b15/jdk-7u25-linux-x64.tar.gz'
node.default['java']['jdk']['7']['x86_64']['checksum'] = '83ba05e260813f7a9140b76e3d37ea33'
node.default['java']['oracle']['accept_oracle_download_terms'] = true

include_recipe 'java'
