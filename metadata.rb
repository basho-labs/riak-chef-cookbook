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

name              "riak"
maintainer        "Basho Technologies, Inc."
maintainer_email  "riak@basho.com"
license           "Apache 2.0"
description       "Installs and configures Riak distributed data store"
version           "1.3.1"
depends           "apt"
depends           "yum"
depends           "build-essential"
depends           "erlang"

recipe            "riak", "Installs Riak from a package"
recipe            "riak::source", "Installs Erlang and Riak from source"


%w{ubuntu debian centos redhat fedora}.each do |os|
  supports os
end
