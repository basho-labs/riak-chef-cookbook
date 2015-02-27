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
default['riak']['package']['enterprise_key'] = ''

default['riak']['package']['version']['major'] = '2'
default['riak']['package']['version']['minor'] = '0'
default['riak']['package']['version']['incremental'] = '2'
default['riak']['package']['version']['build'] = '1'
default['riak']['package']['local']['url'] = ''

default['riak']['package']['local']['checksum'].tap do |checksum|
  checksum['ubuntu']['14']   = 'cab9b89cd0ee82528669facee149c9d6f2a0d0e6fa89496406133ca9c28cd48e'
  checksum['ubuntu']['12']   = 'db290d17208861b2eb8694d2eb3d1dc8e7ad280edf577fac8bd355446ca6b85a'
  checksum['debian']['7']    = '31ca5d472e992e3af267b440945239b110354a64fc197d2a3d73b93fc66483d4'
  checksum['centos']['7']    = '15a732f0b79c934f8dbc3d5b86124a0eedfe7da6e1df84a595df15b2b703106d'
  checksum['centos']['6']    = 'ab51c3d65dcd63c1f8d94bdd241b26671b18fcb19d272f4397d07021cfa71a3c'
  checksum['centos']['5']    = '8b829b6b7349ace62d7a69ccb113ea5d52f5f39f4f39b08c900e5ffed1119cf5'
  checksum['fedora']['19']   = '7f182beaa3c79ac023811d23ef3957a07fabebd128b62fcc77ac710b98c72b98'
  checksum['freebsd']['10']  = '8b3afb7f3896678ed6aca0533d94510db9aa2c59f2bbac8a03277906ab9e8b8b'
  checksum['freebsd']['9']   = '5b67b8f9d8488f848a54e6ee733d67964a2381ee06b35d60044f1f61b3da2f7c'
  checksum['amazon']['2014'] = checksum['centos']['6']
end

default['riak']['package']['enterprise']['checksum'].tap do |checksum|
  checksum['ubuntu']['14']   = '5228de901e41e7b0843b3ed5a26787e29ed5ee8bdfd3f93b4856803022335967'
  checksum['ubuntu']['12']   = '983c4ba5466395095f0208d6208acfb416fe157dc4c27e796c71962e6a05c684'
  checksum['debian']['7']    = 'b86b9200f29b48bbd44b2110ec96662e81b7ac60e096cebdd49feddacf07ae20'
  checksum['centos']['7']    = '31b4f78cd4dfb30ffbdb1ac67adf720be1ac6def5378b6c8221e20fcfc2590ba'
  checksum['centos']['6']    = 'fafe91dc2b858aeed178eebb29a89c082dbd081fe3b66b7827b801b81c309321'
  checksum['centos']['5']    = 'a0b4f563810080e7643c6a2289405145df3bc38b53d83f2608b8cf20898e34bf'
  checksum['fedora']['19']   = '2ebca241f0ecbd547b07dd94e06215afd2507061f1ff47d91f5221a28d06544c'
  checksum['freebsd']['10']  = '630add5aad5d33eb12616e0b79ab5de6dd3c49003aaf06b84237f070c422bbe5'
  checksum['freebsd']['9']   = 'f548cef733a077d3f01efd8586153fe411377323f80bc66f394b151ac485f24a'
  checksum['amazon']['2014'] = checksum['centos']['6']
end
