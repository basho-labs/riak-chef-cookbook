#
# Author:: Hector Castro (<hector@basho.com>)
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
default['riak']['install_method'] = 'package'
default['riak']['manage_java'] = false

# ulimit
default['riak']['limits']['nofile'] = 65_536

default['riak']['platform_bin_dir'] = '/usr/sbin'
default['riak']['platform_data_dir'] = '/var/lib/riak'
default['riak']['platform_etc_dir'] = '/etc/riak'
default['riak']['platform_log_dir'] = '/var/log/riak'

if node.platform_family?('rhel')
  default['riak']['platform_lib_dir'] = '/usr/lib64/riak/lib'
elsif node.platform_family?('freebsd')
  default['riak']['platform_bin_dir'] = '/usr/local/sbin'
  default['riak']['platform_data_dir'] = '/var/db/riak'
  default['riak']['platform_etc_dir'] = '/usr/local/etc/riak'
  default['riak']['platform_lib_dir'] = '/usr/local/lib/riak'
else
  default['riak']['platform_lib_dir'] = '/usr/lib/riak/lib'
end

# patches
default['riak']['patches'] = []

# riak.conf
default['riak']['config']['log.console'] = 'file'
default['riak']['config']['log']['console']['level'] = 'info'
default['riak']['config']['log']['console']['file'] = "#{node['riak']['platform_log_dir']}/console.log"
default['riak']['config']['log']['error']['file'] = "#{node['riak']['platform_log_dir']}/error.log"
default['riak']['config']['log']['syslog'] = 'off'
default['riak']['config']['log.crash'] = 'on'
default['riak']['config']['log']['crash']['file'] = "#{node['riak']['platform_log_dir']}/crash.log"
default['riak']['config']['log']['crash']['maximum_message_size'] = '64KB'
default['riak']['config']['log']['crash']['size'] = '10MB'
default['riak']['config']['log']['crash.rotation'] = '$D0'
default['riak']['config']['log']['crash']['rotation']['keep'] = 5
default['riak']['config']['nodename'] = "riak@#{node['fqdn']}"
default['riak']['config']['distributed_cookie'] = 'riak'
default['riak']['config']['erlang']['async_threads'] = 64
default['riak']['config']['erlang']['max_ports'] = 65_536
default['riak']['config']['erlang']['schedulers']['force_wakeup_interval'] = 500
default['riak']['config']['erlang']['schedulers']['compaction_of_load'] = 'false'
default['riak']['config']['ring_size'] = 64
default['riak']['config']['transfer_limit'] = 2
# default['riak']['config']['ssl']['certfile'] = '$(platform_etc_dir)/cert.pem'
# default['riak']['config']['ssl']['keyfile'] = '$(platform_etc_dir)/key.pem'
# default['riak']['config']['ssl']['cacertfile'] = '$(platform_etc_dir)/cacertfile.pem'
default['riak']['config']['dtrace'] = 'off'
default['riak']['config']['platform_bin_dir'] = node['riak']['platform_bin_dir']
default['riak']['config']['platform_data_dir'] = node['riak']['platform_data_dir']
default['riak']['config']['platform_etc_dir'] = node['riak']['platform_etc_dir']
default['riak']['config']['platform_lib_dir'] = node['riak']['platform_lib_dir']
default['riak']['config']['platform_log_dir'] = node['riak']['platform_log_dir']
default['riak']['config']['strong_consistency'] = 'off'
default['riak']['config']['listener']['http']['internal'] = "#{node['ipaddress']}:8098"
default['riak']['config']['listener']['protobuf']['internal'] = "#{node['ipaddress']}:8087"
default['riak']['config']['protobuf']['backlog'] = 128
# default['riak']['config']['listener']['https']['internal'] = '127.0.0.1:8098'
default['riak']['config']['anti_entropy'] = 'active'
default['riak']['config']['storage_backend'] = 'bitcask'
default['riak']['config']['object']['format'] = 1
default['riak']['config']['object']['size']['warning_threshold'] = '5MB'
default['riak']['config']['object']['size']['maximum'] = '50MB'
default['riak']['config']['object']['siblings']['warning_threshold'] = 25
default['riak']['config']['object']['siblings']['maximum'] = 100
default['riak']['config']['bitcask']['data_root'] = '$(platform_data_dir)/bitcask'
default['riak']['config']['bitcask']['io_mode'] = 'erlang'
default['riak']['config']['riak_control.top_level'] = 'off'
default['riak']['config']['riak_control']['auth']['mode'] = 'off'
# default['riak']['config']['riak_control']['auth']['user']['user']['password'] = 'pass'
default['riak']['config']['leveldb']['maximum_memory']['percent'] = 70
# default['riak']['config']['jmx.top_level'] = 'off'
default['riak']['config']['search.top_level'] = 'off'
default['riak']['config']['search']['solr']['start_timeout'] = '30s'
default['riak']['config']['search']['solr']['port'] = 8093
default['riak']['config']['search']['solr']['jmx_port'] = 8985
default['riak']['config']['search']['solr']['jvm_options'] = '-d64 -Xms1g -Xmx1g -XX:+UseStringCache -XX:+UseCompressedOops'
