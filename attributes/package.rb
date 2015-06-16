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
default['riak']['package']['version']['minor'] = '1'
default['riak']['package']['version']['incremental'] = '1'
default['riak']['package']['version']['build'] = '1'
default['riak']['package']['local']['url'] = ''

default['riak']['package']['local']['checksum'].tap do |checksum|
  checksum['ubuntu']['14']   = '2b28aeabb21488125b7e39f768c8f3b98ac816d1a30c0d618c9f82f99e6e89d9'
  checksum['ubuntu']['12']   = '3671964ed9289434904b1617f382ee6a228c3be1d8dc6e57b918aa8c530a4038'
  checksum['debian']['7']    = '21413331edf57ae912ecdc4d99c7852efd4f58abe5cc26f01c55515b66bcec02'
  checksum['centos']['7']    = '8f801c9a33632a7102b5dcf44eea32e7557c9fd6c5e149acbe9de9d1363319ef'
  checksum['centos']['6']    = '8133c2af6d4ce0b5705ed34fdebc27cca15478ce8dc608cb2855e24f4b6d5f47'
  checksum['centos']['5']    = 'be4a5ccf4f75994fedc4d8c34fe73782df93a160daf079db48671e6c3a2fbbd2'
  checksum['fedora']['19']   = 'd710124c0b322830b0c0aa64711bc722522a57b5edacccbaa7eb31f39984703b'
  checksum['freebsd']['10']  = 'a5f82486d39ac23bef83091ff40bbcebb3ded342d4b73219295ffb05df115fc4'
  checksum['freebsd']['9']   = '7547fd19ee8ddb1a8ae2555c9d0ff859b1ec3e5ecb56cc315eca3500bf905450'
  checksum['amazon']['2014'] = checksum['centos']['6']
end

default['riak']['package']['enterprise']['checksum'].tap do |checksum|
  checksum['ubuntu']['14']   = '0f37783ae2426d60187f24c9edcbf2322db38ff232a7e6b29ca89699ed3c8345'
  checksum['ubuntu']['12']   = '072dec713ad1a4f9f5aa7f76f414b02b5f8cbac769fb497c918f2f19cd88c6c3'
  checksum['debian']['7']    = '6d7da002dafef53f0c8b6b2f45de68629ad0efbd5a67f167bd56fbdc7467664a'
  checksum['centos']['7']    = '52ac620e311caff1d857e705ce717f93d8e53e9fd7d8a29c190007cfed79351c'
  checksum['centos']['6']    = '56266a8ced423f3cb53abd06112fe18a9ecb440c86b98d3de9266198e8283bdc'
  checksum['centos']['5']    = '2ac99621f04be13ac6137bca538fcef427c0e476099b99a6ad6811b9b5e85c6b'
  checksum['fedora']['19']   = '0f6889a81eb32fcd7e823dd5c73d4eb649c25e9f0072e270f50840d0d050141f'
  checksum['freebsd']['10']  = 'df8312ef6ce4c8f0531d4c7a7ff1a6f03852702853955b24989fe1494e979c87'
  checksum['freebsd']['9']   = '05b419392bc0af30a698acd6e3ac2753b2de5bec12a78789e2e6f6b7b1c95d24'
  checksum['amazon']['2014'] = checksum['centos']['6']
end
