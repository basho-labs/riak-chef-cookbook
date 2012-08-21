#
# Author:: Sean Cribbs (<sean@basho.com>)
# Cookbook Name:: riak
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

# package options for source
if (node.riak.package.type.eql?("source"))
  node.default.riak.package.prefix = "/usr/local"
  node.default.riak.package.config_dir = node.riak.package.prefix + "/riak/etc"
end

# platform_dir
case node[:platform]
when "debian","ubuntu"
  node.default.riak.config.riak_core.platform_lib_dir = "/usr/lib/riak"
when "redhat","centos","scientific","fedora","suse"
  if node[:kernel][:machine] == 'x86_64'
    node.default.riak.config.riak_core.platform_lib_dir = "/usr/lib64/riak"
  else 
    node.default.riak.config.riak_core.platform_lib_dir = "/usr/lib/riak"
  end
else
  node.default.riak.config.riak_core.platform_lib_dir = "/usr/lib/riak"
end

# remove unneeded backend options
case node.riak.config.riak_kv.storage_backend
when "riak_kv_bitcask_backend"
  node.riak.config.delete(:eleveldb)
when "riak_kv_eleveldb_backend" 
  node.riak.config.delete(:bitcask)
end
