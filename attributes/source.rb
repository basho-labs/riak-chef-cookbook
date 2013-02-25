#
# Author:: Benjamin Black (<b@b3k.us>) and Sean Cribbs (<sean@basho.com>)
# Cookbook Name:: riak
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
default['riak']['source']['url'] = "http://s3.amazonaws.com/downloads.basho.com/riak"
default['riak']['source']['version']['major'] = "1"
default['riak']['source']['version']['minor'] = "3"
default['riak']['source']['version']['incremental'] = "0"
default['riak']['source']['prefix'] = "/usr/local"
default['riak']['source']['config_dir'] = node['riak']['source']['prefix'] + "/riak/etc"

default['riak']['source']['checksum'] = '424d159a848825614a5e719df7b743dbeee6c1828566a6c9ec2e06c33b0b86fe'

