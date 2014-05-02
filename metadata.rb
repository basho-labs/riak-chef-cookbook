#
# Author:: Benjamin Black (<b@b3k.us>), Sean Cribbs (<sean@basho.com>), Seth Thomas (<sthomas@basho.com>)
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
version           "2.4.9"

recipe            "riak", "Installs Riak from a package"
recipe            "riak::source", "Installs Erlang and Riak from source"

depends "apt", "~> 2.3.8"
depends "build-essential", "~> 1.4.2"
depends "erlang", "~> 1.5.0"
depends "git", "~> 3.0"
depends "sysctl", "~> 0.3.5"
depends "ulimit", "~> 0.3.2"
depends "yum", "~> 3.0"
depends "yum-epel", "~> 0.3"

%w{ubuntu debian centos redhat fedora}.each do |os|
  supports os
end
