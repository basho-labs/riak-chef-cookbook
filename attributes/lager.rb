#
# Author:: Sean Carey (<densone@basho.com>)
# Cookbook Name:: riak
#
# Copyright (c) 2010 Basho Technologies, Inc.
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

default.riak.lager.handlers.lager_console_backend = :info
default.riak.lager.crash_log = "/var/log/riak/crash.log"
default.riak.lager.crash_log_date = "$D0"
default.riak.lager.crash_log_msg_size = 65536
default.riak.lager.crash_log_size = 10485760
default.riak.lager.error_logger_redirect = true 


#{handlers, [
 #   {lager_console_backend, info},
  #  {lager_file_backend, [
   #     {"{{platform_log_dir}}/error.log", error, 10485760, "$D0", 5},
    #    {"{{platform_log_dir}}/console.log", info, 10485760, "$D0", 5}
#    ]}
#]},

