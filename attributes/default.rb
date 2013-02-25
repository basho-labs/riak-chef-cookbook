#
# Author:: Seth Thomas (<sthomas@basho.com>)
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

platform_bin_dir = "/usr/sbin"
platform_data_dir = "/var/lib/riak"
platform_etc_dir = "/etc/riak"
platform_lib_dir = "/usr/lib/riak"
platform_log_dir = "/var/log/riak"

# vm.args
default['riak']['args']['-name'] = "riak@#{node['fqdn']}"
default['riak']['args']['-setcookie'] = "riak"
default['riak']['args']['+K'] = true
default['riak']['args']['+A'] = 64
default['riak']['args']['+W'] = "w"
default['riak']['args']['-env']['ERL_MAX_PORTS'] = 4096
default['riak']['args']['-env']['ERL_FULLSWEEP_AFTER'] = 0
default['riak']['args']['-env']['ERL_CRASH_DUMP'] = "#{platform_log_dir}/erl_crash.dump"
default['riak']['args']['-env']['ERL_MAX_ETS_TABLES'] = 8192
default['riak']['args']['-smp'] =  "enable"
#default['riak']['args']['-proto_dist'] = "inet_ssl"
#default['riak']['args']['-ssl_dist_opt']['client_certfile'] = "\"#{platform_etc_dir}/erlclient.pem\""
#default['riak']['args']['-ssl_dist_opt']['server_certfile'] = "\"#{platform_etc_dir}/erlserver.pem\""

# app.config
class ::String
  include Eth::Erlang::String
end

class ::Array
  include Eth::Erlang::Array
end

# kernel
default['riak']['config']['kernel']['inet_dist_listen_min'] = 6000
default['riak']['config']['kernel']['inet_dist_listen_max'] = 7999

# riak_api
default['riak']['config']['riak_api']['pb_backlog'] = 64
default['riak']['config']['riak_api']['pb_ip'] = "#{node['ipaddress']}".to_erl_string
default['riak']['config']['riak_api']['pb_port'] = 8087

# riak_core
default['riak']['config']['riak_core']['ring_state_dir'] = "#{platform_data_dir}/ring".to_erl_string
default['riak']['config']['riak_core']['ring_creation_size'] = 64
default['riak']['config']['riak_core']['http'] = [["#{node['ipaddress']}".to_erl_string, 8098].to_erl_tuple]
#default['riak']['config']['riak_core']['https'] = [["#{node['ipaddress']}".to_erl_string, 8098].to_erl_tuple]
#default['riak']['config']['riak_core']['ssl'] = [["certfile", "./etc/cert.pem".to_erl_string].to_erl_tuple, ["keyfile", "./etc/key.pem".to_erl_string].to_erl_tuple]
default['riak']['config']['riak_core']['handoff_port'] = 8099
#default['riak']['config']['riak_core']['handoff_ssl_options'] = [["certfile", "tmp/erlserver.pem".to_erl_string].to_erl_tuple]
default['riak']['config']['riak_core']['dtrace_support'] = false
default['riak']['config']['riak_core']['enable_health_checks'] = true
default['riak']['config']['riak_core']['platform_bin_dir'] = platform_bin_dir.to_erl_string
default['riak']['config']['riak_core']['platform_data_dir'] = platform_data_dir.to_erl_string
default['riak']['config']['riak_core']['platform_etc_dir'] = platform_etc_dir.to_erl_string
default['riak']['config']['riak_core']['platform_lib_dir'] = platform_lib_dir.to_erl_string
default['riak']['config']['riak_core']['platform_log_dir'] = platform_log_dir.to_erl_string

# riak_kv
default['riak']['config']['riak_kv']['anti_entropy'] = ["on", []].to_erl_tuple
default['riak']['config']['riak_kv']['anti_entropy_build_limit'] = [1, 3600000].to_erl_tuple
default['riak']['config']['riak_kv']['anti_entropy_expire'] = 604800000
default['riak']['config']['riak_kv']['anti_entropy_concurrency'] = 2
default['riak']['config']['riak_kv']['anti_entropy_tick'] = 1500
default['riak']['config']['riak_kv']['anti_entropy_data_dir'] = "#{platform_data_dir}/anti_entropy".to_erl_string
default['riak']['config']['riak_kv']['anti_entropy_leveldb_opts'] = [["write_buffer_size", 4194304].to_erl_tuple, ["max_open_files", 20].to_erl_tuple]
default['riak']['config']['riak_kv']['mapred_name'] = "mapred".to_erl_string
default['riak']['config']['riak_kv']['mapred_system'] = "pipe"
default['riak']['config']['riak_kv']['mapred_2i_pipe'] = true
default['riak']['config']['riak_kv']['map_js_vm_count'] = 8
default['riak']['config']['riak_kv']['reduce_js_vm_count'] = 6
default['riak']['config']['riak_kv']['hook_js_vm_count'] = 2
default['riak']['config']['riak_kv']['js_max_vm_mem'] = 8
default['riak']['config']['riak_kv']['js_thread_stack'] = 16
#default['riak']['config']['riak_kv']['js_source_dir'] = "/tmp/js_source".to_erl_string
default['riak']['config']['riak_kv']['http_url_encoding'] = "on"
default['riak']['config']['riak_kv']['vnode_vclocks'] = true
default['riak']['config']['riak_kv']['listkeys_backpressure'] = true
default['riak']['config']['riak_kv']['vnode_mailbox_limit'] = [1, 5000].to_erl_tuple

# riak_kv storage_backend
default['riak']['config']['riak_kv']['storage_backend'] = "riak_kv_bitcask_backend"
case node['riak']['config']['riak_kv']['storage_backend']
  when "riak_kv_bitcask_backend"
    default['riak']['config']['bitcask']['io_mode'] = "erlang"
    default['riak']['config']['bitcask']['data_root'] = "#{platform_data_dir}/bitcask".to_erl_string
  when "riak_kv_eleveldb_backend"
    default['riak']['config']['eleveldb']['data_root'] = "#{platform_data_dir}/leveldb".to_erl_string
end

# riak_search
default['riak']['config']['riak_search']['enabled'] = false

# merge_index
default['riak']['config']['merge_index']['data_root'] = "#{platform_data_dir}/merge_index".to_erl_string
default['riak']['config']['merge_index']['buffer_rollover_size'] = 1048576
default['riak']['config']['merge_index']['max_compact_segments'] = 20

# lager
error_log = ["#{platform_log_dir}/error.log".to_erl_string,"error",10485760,"$D0".to_erl_string,5].to_erl_tuple
info_log = ["#{platform_log_dir}/console.log".to_erl_string,"info",10485760,"$D0".to_erl_string,5].to_erl_tuple
default['riak']['config']['lager']['handlers']['lager_file_backend'] = [error_log, info_log]
default['riak']['config']['lager']['crash_log'] = "#{platform_log_dir}/crash.log".to_erl_string
default['riak']['config']['lager']['crash_log_msg_size'] = 65536
default['riak']['config']['lager']['crash_log_size'] = 10485760
default['riak']['config']['lager']['crash_log_date'] = "$D0".to_erl_string
default['riak']['config']['lager']['crash_log_count'] = 5
default['riak']['config']['lager']['error_logger_redirect'] = true

# riak_sysmon
default['riak']['config']['riak_sysmon']['process_limit'] = 30
default['riak']['config']['riak_sysmon']['port_limit'] = 2
default['riak']['config']['riak_sysmon']['gc_ms_limit'] = 0
default['riak']['config']['riak_sysmon']['heap_word_limit'] = 40111000
default['riak']['config']['riak_sysmon']['busy_port'] = true
default['riak']['config']['riak_sysmon']['busy_dist_port'] = true

# sasl
default['riak']['config']['sasl']['sasl_error_logger'] = false
default['riak']['config']['sasl']['utc_log'] = true

# riak_control
default['riak']['config']['riak_control']['enabled'] = false
default['riak']['config']['riak_control']['auth'] = "userlist"
default['riak']['config']['riak_control']['userlist'] = [["user".to_erl_string,"pass".to_erl_string].to_erl_tuple]
default['riak']['config']['riak_control']['admin'] = true

#patches
default['riak']['patches'] = []
