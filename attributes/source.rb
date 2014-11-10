#
# Author:: Benjamin Black (<b@b3k.us>) and Sean Cribbs (<sean@basho.com>)
# Cookbook Name:: riak
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
default['riak']['source']['url'] = 'http://s3.amazonaws.com/downloads.basho.com/riak'
default['riak']['source']['version']['major'] = '2'
default['riak']['source']['version']['minor'] = '0'
default['riak']['source']['version']['incremental'] = '2'
default['riak']['source']['prefix'] = '/opt'

default['riak']['source']['checksum'] = 'c593c02d520f5a1d006df92fea59fc0152ae60c118fd5f1150a29b994b84911c'
