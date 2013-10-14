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
include_attribute "riak::package"

# install method
default['riak']['install_method'] = "package"

# directories
default['riak']['bin_dir'] = "/usr/sbin"
default['riak']['data_dir'] = "/var/lib/riak"
default['riak']['etc_dir'] = "/etc/riak"
default['riak']['lib_dir'] = "/usr/lib/riak"
default['riak']['log_dir'] = "/var/log/riak"

# vm.args
default['riak']['args']['-name'] = "riak@#{node['fqdn']}"
default['riak']['args']['-setcookie'] = "riak"
default['riak']['args']['+K'] = true
default['riak']['args']['+A'] = 64
default['riak']['args']['+W'] = "w"
default['riak']['args']['-env']['ERL_MAX_PORTS'] = 64000
default['riak']['args']['-env']['ERL_FULLSWEEP_AFTER'] = 0
default['riak']['args']['-env']['ERL_CRASH_DUMP'] = "#{node['riak']['log_dir']}/erl_crash.dump"
default['riak']['args']['-env']['ERL_MAX_ETS_TABLES'] = 256000
default['riak']['args']['-smp'] =  "enable"
#default['riak']['args']['+zdbbl'] = 32768
#default['riak']['args']['+P'] = 256000
#default['riak']['args']['+sfwi'] = 500
#default['riak']['args']['-proto_dist'] = "inet_ssl"
#default['riak']['args']['-ssl_dist_opt']['client_certfile'] = "\"#{node['riak']['etc_dir']}/erlclient.pem\""
#default['riak']['args']['-ssl_dist_opt']['server_certfile'] = "\"#{node['riak']['etc_dir']}/erlserver.pem\""

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
#default['riak']['config']['riak_api']['pb_backlog'] = 64
if node['riak']['package']['version']['major'].to_i >= 1 && node['riak']['package']['version']['minor'].to_i >= 4
  default['riak']['config']['riak_api']['pb'] = [[node['ipaddress'].to_erl_string, 8087].to_erl_tuple]
else
  default['riak']['config']['riak_api']['pb_ip'] = node['ipaddress'].to_erl_string
  default['riak']['config']['riak_api']['pb_port'] = 8087
end

# riak_core
default['riak']['config']['riak_core']['ring_state_dir'] = "#{node['riak']['data_dir']}/ring".to_erl_string
default['riak']['config']['riak_core']['ring_creation_size'] = 64
default['riak']['config']['riak_core']['http'] = [[node['ipaddress'].to_erl_string, 8098].to_erl_tuple]
#default['riak']['config']['riak_core']['https'] = [["#{node['ipaddress']}".to_erl_string, 8098].to_erl_tuple]
#default['riak']['config']['riak_core']['ssl'] = [["certfile", "./etc/cert.pem".to_erl_string].to_erl_tuple, ["keyfile", "./etc/key.pem".to_erl_string].to_erl_tuple]
default['riak']['config']['riak_core']['handoff_port'] = 8099
#default['riak']['config']['riak_core']['handoff_ssl_options'] = [["certfile", "tmp/erlserver.pem".to_erl_string].to_erl_tuple]
default['riak']['config']['riak_core']['cluster_mgr'] = [node['ipaddress'].to_erl_string, 9085].to_erl_tuple
default['riak']['config']['riak_core']['dtrace_support'] = false
#default['riak']['config']['riak_core']['enable_health_checks'] = true
default['riak']['config']['riak_core']['platform_bin_dir'] = node['riak']['bin_dir'].to_erl_string
default['riak']['config']['riak_core']['platform_data_dir'] = node['riak']['data_dir'].to_erl_string
default['riak']['config']['riak_core']['platform_etc_dir'] = node['riak']['etc_dir'].to_erl_string
default['riak']['config']['riak_core']['platform_lib_dir'] = node['riak']['lib_dir'].to_erl_string
default['riak']['config']['riak_core']['platform_log_dir'] = node['riak']['log_dir'].to_erl_string

# riak_kv
default['riak']['config']['riak_kv']['anti_entropy'] = ["on", []].to_erl_tuple
default['riak']['config']['riak_kv']['anti_entropy_build_limit'] = [1, 3600000].to_erl_tuple
default['riak']['config']['riak_kv']['anti_entropy_expire'] = 604800000
default['riak']['config']['riak_kv']['anti_entropy_concurrency'] = 2
default['riak']['config']['riak_kv']['anti_entropy_tick'] = 15000
default['riak']['config']['riak_kv']['anti_entropy_data_dir'] = "#{node['riak']['data_dir']}/anti_entropy".to_erl_string
default['riak']['config']['riak_kv']['anti_entropy_leveldb_opts'] = [["write_buffer_size", 4194304].to_erl_tuple, ["max_open_files", 20].to_erl_tuple]
default['riak']['config']['riak_kv']['mapred_name'] = "mapred".to_erl_string
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
default['riak']['config']['riak_kv']['fsm_limit'] = 50000
default['riak']['config']['riak_kv']['object_format'] = "v1"

# riak_kv storage_backend
default['riak']['config']['riak_kv']['storage_backend'] = "riak_kv_bitcask_backend"
case node['riak']['config']['riak_kv']['storage_backend']
  when "riak_kv_bitcask_backend"
    default['riak']['config']['bitcask']['io_mode'] = "erlang"
    default['riak']['config']['bitcask']['data_root'] = "#{node['riak']['data_dir']}/bitcask".to_erl_string
  when "riak_kv_eleveldb_backend"
    default['riak']['config']['eleveldb']['data_root'] = "#{node['riak']['data_dir']}/leveldb".to_erl_string
  when "riak_kv_multi_backend"
    default['riak']['config']['riak_kv']['multi_backend_default'] = "bitcask_mult"
    bitcask_mult = ["bitcask_mult", "riak_kv_bitcask_backend", {"data_root" => "#{node['riak']['data_dir']}/bitcask".to_erl_string}]
    eleveldb_mult = ["eleveldb_mult", "riak_kv_eleveldb_backend", {"data_root" => "#{node['riak']['data_dir']}/leveldb".to_erl_string}]
    default['riak']['config']['riak_kv']['multi_backend'] = [bitcask_mult.to_erl_tuple, eleveldb_mult.to_erl_tuple]
  when "riak_cs_kv_multi_backend"
    default['riak']['cs_version'] = "1.4.1"
    if node['platform_family'] == "rhel" && node['kernel']['machine'] == "x86_64"
       default['riak']['config']['riak_kv']['add_paths'] = ["/usr/lib64/riak-cs/lib/riak_cs-#{node['riak']['cs_version']}/ebin".to_erl_string]
    else
       default['riak']['config']['riak_kv']['add_paths'] = ["/usr/lib/riak-cs/lib/riak_cs-#{node['riak']['cs_version']}/ebin".to_erl_string]
    end
    prefix_list = ["0b:".to_erl_binary, "be_blocks"]
    default['riak']['config']['riak_kv']['multi_backend_prefix_list'] = [prefix_list.to_erl_tuple]
    default['riak']['config']['riak_kv']['multi_backend_default'] = "be_default"
    be_default = ["be_default", "riak_kv_eleveldb_backend", {"data_root" => "#{node['riak']['data_dir']}/leveldb".to_erl_string, "max_open_files" => 50}]
    be_blocks = ["be_blocks", "riak_kv_bitcask_backend", {"data_root" => "#{node['riak']['data_dir']}/bitcask".to_erl_string}]
    default['riak']['config']['riak_kv']['multi_backend'] = [be_default.to_erl_tuple, be_blocks.to_erl_tuple]
    default['riak']['config']['riak_core']['default_bucket_props'] = [ ['allow_mult', true].to_erl_tuple ]
end

# riak_search
default['riak']['config']['riak_search']['enabled'] = false

# merge_index
default['riak']['config']['merge_index']['data_root'] = "#{node['riak']['data_dir']}/merge_index".to_erl_string
default['riak']['config']['merge_index']['buffer_rollover_size'] = 1048576
default['riak']['config']['merge_index']['max_compact_segments'] = 20

# lager
error_log = ["#{node['riak']['log_dir']}/error.log".to_erl_string,"error",10485760,"$D0".to_erl_string,5].to_erl_tuple
info_log = ["#{node['riak']['log_dir']}/console.log".to_erl_string,"info",10485760,"$D0".to_erl_string,5].to_erl_tuple
default['riak']['config']['lager']['handlers']['lager_file_backend'] = [error_log, info_log]
default['riak']['config']['lager']['crash_log'] = "#{node['riak']['log_dir']}/crash.log".to_erl_string
default['riak']['config']['lager']['crash_log_msg_size'] = 65536
default['riak']['config']['lager']['crash_log_size'] = 10485760
default['riak']['config']['lager']['crash_log_date'] = "$D0".to_erl_string
default['riak']['config']['lager']['crash_log_count'] = 5
default['riak']['config']['lager']['error_logger_redirect'] = true
default['riak']['config']['lager']['error_logger_hwm'] = 100

# riak_sysmon
default['riak']['config']['riak_sysmon']['process_limit'] = 30
default['riak']['config']['riak_sysmon']['port_limit'] = 2
default['riak']['config']['riak_sysmon']['gc_ms_limit'] = 0
default['riak']['config']['riak_sysmon']['heap_word_limit'] = 40111000
default['riak']['config']['riak_sysmon']['busy_port'] = true
default['riak']['config']['riak_sysmon']['busy_dist_port'] = true

# sasl
default['riak']['config']['sasl']['sasl_error_logger'] = false

# riak_control
default['riak']['config']['riak_control']['enabled'] = false
default['riak']['config']['riak_control']['auth'] = "userlist"
default['riak']['config']['riak_control']['userlist'] = [["user".to_erl_string,"pass".to_erl_string].to_erl_tuple]
default['riak']['config']['riak_control']['admin'] = true

# riak_repl
default['riak']['config']['riak_repl']['data_root'] = "#{node['riak']['data_dir']}/riak_repl".to_erl_string

#jmx config options
default['riak']['config']['riak_jmx']['enabled'] = false

#snmp config options
default['riak']['config']['snmp']['agent']['net_if']['options']['bind_to'] = true
default['riak']['config']['snmp']['agent']['config']['dir'] = "#{node['riak']['etc_dir']}/snmp/agent/conf".to_erl_string
default['riak']['config']['snmp']['agent']['config']['force_load'] = true
default['riak']['config']['snmp']['agent']['db_dir'] = "#{node['riak']['data_dir']}/snmp/agent/db".to_erl_string

# limits
default['riak']['limits']['nofile'] = 4096

#patches
default['riak']['patches'] = []
