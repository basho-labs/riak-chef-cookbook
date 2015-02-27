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
default['riak']['package']['version']['incremental'] = '5'
default['riak']['package']['version']['build'] = '1'
default['riak']['package']['local']['url'] = ''

default['riak']['package']['local']['checksum'].tap do |checksum|
  checksum['ubuntu']['14']   = '186f6b4890bb72aaab5c0a2b6cd31ff90f2098d8a50c955a8ed3a80e26d67c57'
  checksum['ubuntu']['12']   = 'cad764ad5296c6d9a8d4b2bd4e60ece218a72206ea3369c9eb36d43c6737f5e6'
  checksum['debian']['7']    = '4aa02b5e442fface7e17d00bd1958aecbfe5377d44005a87f85b0f17b723a974'
  checksum['centos']['7']    = '6151acd0be1b916600c13da4cf55811afe055a0fc6a253a7e75751e239aff584'
  checksum['centos']['6']    = '25434359e61eb284a595160fec552854b0971ffee3a569bdf9957c5cf04643b6'
  checksum['centos']['5']    = '2fc3cc3e151bce4b4774bd503658b92f973e78ecae0ce2912cff19023a547638'
  checksum['fedora']['19']   = 'f4213903776d50f336184fc0fb57a1d173d03a51838e84030dc82400598951fc'
  checksum['freebsd']['10']  = '51030f81a5165baea71f17ba70d1ded47937c5893ae115de8353b09f96846196'
  checksum['freebsd']['9']   = '408d4ee01b07c95c8f5fbe8d2236a4c79c77e0a0ec9fb1967da4cc9b0cde7c32'
  checksum['amazon']['2014'] = checksum['centos']['6']
end

default['riak']['package']['enterprise']['checksum'].tap do |checksum|
  checksum['ubuntu']['14']   = '9067483379c3850603c84d68205e5dd2dbda7b05dddeb1c5f6a0635c645e7c60'
  checksum['ubuntu']['12']   = '64732720e3576c05854728f885fd4d16822be4d5072fd279a84c3b1cb39a238b'
  checksum['debian']['7']    = '33be225c6db815f0a6dbbdb26c5de3bb75cb0392f1748edd9711b56d77f22207'
  checksum['centos']['7']    = 'c5332a5ee767526fd7633346042d50cfbe2b8393ba2541a62028f2739df62e86'
  checksum['centos']['6']    = '2c3e46b01ae6c6715f32b8ff2d41c9818955412f079f25d374732182f4264b0e'
  checksum['centos']['5']    = '77f890b6a9856144863bc2df7c9d361c340f3356263d6e0ed171e1c8ded0f5c7'
  checksum['fedora']['19']   = '00eea47bca420d9a7e0a84679c0ee00a98b6058efa4156356765feb97a4290e5'
  checksum['freebsd']['10']  = 'c9fda9077c6e4741cd8200d12a5f963bef0cebe2e09ae432ef17e6299c6ab65e'
  checksum['freebsd']['9']   = '153305c12085acc6cd2440a71c177872d7d3fd0a9b5c2647ab81a09d5ca4d670'
  checksum['amazon']['2014'] = checksum['centos']['6']
end
