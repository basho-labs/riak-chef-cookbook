#
# Author:: Benjamin Black (<b@b3k.us>) and Sean Cribbs (<sean@basho.com>)
# Cookbook Name:: riak
#
# Copyright (c) 2011 Basho Technologies, Inc.
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

# package

default['riak']['package']['type'] = "binary"
default['riak']['package']['version']['major'] = "1"
default['riak']['package']['version']['minor'] = "1"
default['riak']['package']['version']['incremental'] = "4"
default['riak']['package']['version']['build'] = "1"
default['riak']['package']['source_checksum'] = '202c7b969a8b389cde176f267ab4f90fb17dc71c6a2b785fc67915719d0b06f2'
default['riak']['package']['config_dir'] = "/etc/riak"

# core

case node['platform']
  when "debian","ubuntu"
    default['riak']['core']['platform_lib_dir'] = "/usr/lib/riak"
  when "redhat","centos","scientific","fedora","suse","amazon"
    if node['kernel']['machine'] == 'x86_64'
      default['riak']['core']['platform_lib_dir'] = "/usr/lib64/riak"
    else
      default['riak']['core']['platform_lib_dir'] = "/usr/lib/riak"
    end
  else
    default['riak']['core']['platform_lib_dir'] = "/usr/lib/riak"
end

default['riak']['core']['http'] = [["127.0.0.1",8098]]
default['riak']['core']['ring_state_dir'] = "/var/lib/riak/ring"
default['riak']['core']['handoff_port'] = 8099
default['riak']['core']['cluster_name'] = "default"
default['riak']['core']['platform_bin_dir'] = "/usr/sbin"
default['riak']['core']['platform_etc_dir'] = "/etc/riak"
default['riak']['core']['platform_data_dir'] = "/var/lib/riak"

# erlang

default['riak']['erlang']['node_name'] = "riak@127.0.0.1"
default['riak']['erlang']['cookie'] = "riak"
default['riak']['erlang']['kernel_polling'] = true
default['riak']['erlang']['async_threads'] = 64
default['riak']['erlang']['error_logger_warnings'] = :w
default['riak']['erlang']['smp'] = "enable"
default['riak']['erlang']['env_vars']['ERL_MAX_PORTS'] = 4096
default['riak']['erlang']['env_vars']['ERL_FULLSWEEP_AFTER'] = 0
default['riak']['erlang']['env_vars']['ERL_CRASH_DUMP'] = "/var/log/riak/erl_crash.dump"

# kernel

default['riak']['kernel']['limit_port_range'] = true
default['riak']['kernel']['inet_dist_listen_min'] = 6000
default['riak']['kernel']['inet_dist_listen_max'] = 7999

# sasl

default['riak']['sasl']['sasl_error_logger'] = false
default['riak']['sasl']['errlog_type'] = :error
default['riak']['sasl']['error_logger_mf_dir'] = "/var/log/riak/sasl"
default['riak']['sasl']['error_logger_mf_maxbytes'] = 10485760
default['riak']['sasl']['error_logger_mf_maxfiles'] = 5

# err

default['riak']['err']['term_max_size'] = 65536
default['riak']['err']['fmt_max_bytes'] = 65536

# lager

default['riak']['lager']['handlers']['lager_console_backend'] = :info
default['riak']['lager']['crash_log'] = "/var/log/riak/crash.log"
default['riak']['lager']['crash_log_date'] = "$D0"
default['riak']['lager']['crash_log_msg_size'] = 65536
default['riak']['lager']['crash_log_size'] = 10485760
default['riak']['lager']['crash_log_count'] = 5
default['riak']['lager']['error_logger_redirect'] = true

# The following two attributes are KEYLESS.
# They hold these values:[NAME,LOG_LEVEL,SIZE,DATE_FORMAT,ROTATION_TO_KEEP]
default['riak']['lager']['handlers']['lager_file_backend']['lager_error_log'] = ["/var/log/riak/error.log", :error, 10485760, "$D0", 5]
default['riak']['lager']['handlers']['lager_file_backend']['lager_console_log'] = ["/var/log/riak/console.log", :info, 10485760, "$D0", 5]

# sysmon

default['riak']['sysmon']['process_limit'] = 30
default['riak']['sysmon']['port_limit'] = 2
default['riak']['sysmon']['gc_ms_limit'] = 100
default['riak']['sysmon']['heap_word_limit'] = 40111000
default['riak']['sysmon']['busy_port'] = true
default['riak']['sysmon']['busy_dist_port'] = true

# merge

default['riak']['merge_index']['data_root'] = "/var/lib/riak/merge_index"
default['riak']['merge_index']['data_root_2i'] = "/var/lib/riak/merge_index_2i"
default['riak']['merge_index']['buffer_rollover_size'] = 1048576
default['riak']['merge_index']['max_compact_segments'] = 20


# riak control

default['riak']['control']['enabled'] = :false
default['riak']['control']['auth'] = :userlist
default['riak']['control']['userlist']['default_user'] = ["user","pass"]
default['riak']['controlvadmin'] = :true

# search

default['riak']['search']['enabled'] = false

# kv

default['riak']['kv']['mapred_queue_dir'] = "/var/lib/riak/mr_queue"
default['riak']['kv']['mapred_name'] = "mapred"
default['riak']['kv']['mapred_system'] = :pipe
default['riak']['kv']['mapred_2i_pipe'] = true
default['riak']['kv']['map_js_vm_count'] = 8
default['riak']['kv']['reduce_js_vm_count'] = 6
default['riak']['kv']['hook_js_vm_count'] = 2
default['riak']['kv']['js_max_vm_mem'] = 8
default['riak']['kv']['js_thread_stack'] = 16
default['riak']['kv']['http_url_encoding'] = "on"
default['riak']['kv']['raw_name'] = "riak"
default['riak']['kv']['riak_kv_stat'] = true
default['riak']['kv']['legacy_stats'] = true
default['riak']['kv']['vnode_vclocks'] = true
default['riak']['kv']['legacy_keylisting'] = false
default['riak']['kv']['pb_ip'] = "127.0.0.1"
default['riak']['kv']['pb_port'] = 8087

# net_dev

default['riak']['net_dev_int'] = "eth0"


# bitcask

default['riak']['bitcask']['sync_strategy'] = :none
default['riak']['bitcask']['data_root'] = "/var/lib/riak/bitcask"

# dets

default['riak']['kv']['riak_kv_dets_backend_root'] = "/var/lib/riak/dets"

# eleveldb

default['riak']['eleveldb']['data_root'] = "/var/lib/riak/leveldb"

# innostore

default['riak']['innostore']['log_buffer_size'] = 8388608
default['riak']['innostore']['log_files_in_group'] = 8
default['riak']['innostore']['log_file_size'] = 268435456
default['riak']['innostore']['flush_log_at_trx_commit'] = 1
default['riak']['innostore']['data_home_dir'] = "/var/lib/riak/innodb"
default['riak']['innostore']['log_group_home_dir'] = "/var/lib/riak/innodb"
default['riak']['innostore']['buffer_pool_size'] = 2147483648
default['riak']['innostore']['flush_method'] = "O_DIRECT"

# +-------------------------+
# | Standard Single Backend |
# +-------------------------+
#
#default['riak']['kv']['storage_backend = :riak_kv_eleveldb_backend

# +-------------------------+
# |  Multi Backend for CS   |
# +-------------------------+

default['riak']['kv']['storage_backend'] = :riak_cs_kv_multi_backend
default['riak']['kv']['multi_backend_prefix_list'] = {':<<"0b:">>' => :be_blocks}
default['riak']['kv']['multi_backend_default'] = :be_default

default['riak']['kv']['multi_backend.backend1'] = [:be_default, :riak_kv_eleveldb_backend, {:max_open_files => 50,:data_root => "/var/lib/riak/leveldb"} ]
default['riak']['kv']['multi_backend.backend2'] = [:be_blocks, :riak_kv_bitcask_backend,   {:data_root => "/var/lib/riak/bitcask"} ]

# +-------------------------+
# |  Multi Backend NOT CS   |
# +-------------------------+
#
#default['riak']['kv']['storage_backend'] = :riak_kv_multi_backend
#default['riak']['kv']['multi_backend_default'] = ':<<"bitcask_mult">>'

## format:                    .anyname  = [         name                   ,           module          ,               [Configs]                 ]
#default['riak']['kv']['multi_backend.backend1'] = [':<<"bitcask_mult">>'         , :riak_kv_bitcask_backend  , {:data_root => "/var/lib/riak/bitcask"} ]
#default['riak']['kv']['multi_backend.backend2'] = [':<<"eleveldb_mult">>'        , :riak_kv_eleveldb_backend , {:max_open_files => 50, :data_root => "/var/lib/riak/leveldb"} ]
#default['riak']['kv']['multi_backend.backend3'] = [':<<"second_eleveldb_mult">>' , :riak_kv_eleveldb_backend , {:max_open_files => 35, :data_root => "/var/lib/riak/leveldb"} ]
#default['riak']['kv']['multi_backend.backend4'] = [':<<"memory_mult">>'          , :riak_kv_memory_backend   , {:max_memory => 4096, :ttl => 86400} ]
