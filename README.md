Riak Cookbook
=============

Overview
========

Riak is a Dynamo-inspired key/value store that scales predictably and easily.  Riak combines a decentralized key/value store, a flexible map/reduce engine, and a friendly HTTP/JSON query interface to provide a database ideally suited for Web applications. And, without any object-relational mappers and other heavy middleware, applications built on Riak can be both simpler and more powerful.  For complete documentation and source code, see the Riak home page at [Basho][1].


Getting Started
===============

The Riak cookbook can be used just by adding "riak" to the runlist for a node.  The default settings will cause Riak to be installed and configured. All the config options exist in the `node['riak']['config']` namespace and can be set to the appropriate Erlang data type with the methods : to_erl_string and to_erl_tuple . For more information see the [erlang_template_helper repository][6] 


Package Installation
--------------------

There are two options for package installation: binary and source.  If you are using a Red Hat, CentOS, Fedora, Debian or Ubuntu distributions, binary installation is recommended and is the default.  If you choose to do a source installation, be sure you are using Erlang/OTP R15B01 or later.

The package parameters available are version, type and, optionally for source installation, an install prefix:

	node['riak']['package']['version']['major'] = "1"
	node['riak']['package']['version']['minor'] = "2"
	node['riak']['package']['version']['incremental'] = "0"
	node['riak']['package']['type'] = ("binary" | "source")
	node['riak']['package']['prefix'] = "/usr/local"


Basic Configuration
-------------------

Most Riak configuration is for networking, Erlang, and storage backends.  The only, interesting configuration options outside of those is the filesystem path where ring state files should be stored.

	node['riak']['config']['riak_core']['ring_state_dir'] = "/var/lib/riak/ring".to_erl_string


Networking
----------

Riak clients communicate with the nodes in the cluster through either the HTTP or Protobufs interfaces, both of which may be used simultaneously.  Configuration for each interface includes the IP address and TCP port on which to listen for client connections.  The default for the HTTP interface is localhost:8098 and for Protobufs 0.0.0.0:8087, meaning client connections to any address on the server, TCP port 8087, are accepted.  As the default HTTP configuration is inaccessible to other nodes, it must be changed if you want clients to use the HTTP interface.

	node['riak']['config']['riak_core']['http'] = [["127.0.0.1", 8098]]
	node['riak']['config']['riak_api']['pb_ip'] = "0.0.0.0"
	node['riak']['config']['riak_api']['pb_port'] = 8087

Intra-cluster handoff occurs over a dedicated port, which defaults to 8099.

	node['riak']['config']['riak_core']['handoff_port'] = 8099

Finally, by default, options are included in the configuration to define the set of ports used for Erlang inter-node communication.  

	node['riak']['config']['kernel']['inet_dist_listen_min'] = 6000
	node['riak']['config']['kernel']['inet_dist_listen_max'] = 7999

Erlang
------

A number of Erlang parameters may be configured through the cookbook.  The node name and cookie are most important for creating multi-node clusters.  The rest of the parameters are primarily for performance tuning, with kernel polling and smp enabled by default.  Any available Erlang environment variable may be set with the env vars hash. 

	node['riak']['args']['-name'] = "riak@#{node['ipaddress']}"
	node['riak']['args']['-setcookie'] = "riak"
	node['riak']['args']['+K'] = (true | false)
	node['riak']['args']['+A'] = 64
	node['riak']['args']['+W'] = "w"
	node['riak']['args']['-env']['ERL_MAX_PORTS'] = 4096
	node['riak']['args']['-env']['ERL_FULLSWEEP_AFTER'] = 0
	node['riak']['args']['-env']['ERL_CRASH_DUMP'] = "/var/log/riak/erl_crash.dump"

Storage Backends
================

Riak requires specification of a storage backend along with various backend storage options, specific to each backend.  While Riak supports specification of different backends for different buckets, the Chef cookbook does not yet allow such configurations. The backend options are Bitcask (the default) or LevelDB.  The typical configuration options and their defaults are given below.


Bitcask
-------
[Bitcask][2] is an Erlang application that provides an API for storing and retrieving key/value data into a log-structured hash table that provides very fast access.

	node['riak']['config']['bitcask']['data_root'] = "/var/lib/riak/bitcask".to_erl_string
	node['riak']['config']['bitcask']['max_file_size'] = 2147483648
	node['riak']['config']['bitcask']['open_timeout'] = 4
	node['riak']['config']['bitcask']['sync_strategy'] = "none"
	node['riak']['config']['bitcask']['frag_merge_trigger'] = 60
	node['riak']['config']['bitcask']['dead_bytes_merge_trigger'] = 536870912
	node['riak']['config']['bitcask']['frag_threshold'] = 40
	node['riak']['config']['bitcask']['dead_bytes_threshold'] = 134217728
	node['riak']['config']['bitcask']['small_file_threshold'] = 10485760
	node['riak']['config']['bitcask']['expiry_secs'] = -1


eLevelDB
--------

[eLevelDB][3] is an Erlang application that encapsulates LevelDB, an open source on-disk key-value store written by Google Fellows Jeffrey Dean and Sanjay Ghemawat. LevelDB's storage architecture is more like BigTable's memtable/sstable model than it is like Bitcask.

	node['riak']['config']['eleveldb']['data_root'] = "/var/lib/riak/leveldb".to_erl_string

Lager 
-----

[Lager][4] is the logging framework used within Riak. It can also be used with erlang/OTP. 


	node['riak']['config']['lager']['crash_log'] = "/var/log/riak/crash.log".to_erl_string
	node['riak']['config']['lager']['crash_log_date'] = "$D0".to_erl_string
	node['riak']['config']['lager']['crash_log_msg_size']  = 65536
	node['riak']['config']['lager']['crash_log_size'] = 10485760
	node['riak']['config']['lager']['error_logger_redirect'] = true
	node['riak']['config']['lager']['handlers']['lager_file_backend']['lager_error_log'] =  ["/var/log/riak/error.log".to_erl_string, "error", 10485760, "$D0".to_erl_string, 5].to_erl_tuple
	node['riak']['config']['lager']['handlers']['lager_file_backend']['lager_console_log'] = ["/var/log/riak/console.log".to_erl_string, "info", 10485760, "$D0".to_erl_string, 5].to_erl_tuple

Sysmon 
------

Sysmon monitors riaks gc process and logs relevant information to the status of garbage collection.

	node['riak']['config']['sysmon']['process_limit'] = 30
	node['riak']['config']['sysmon']['port_limit'] = 30
	node['riak']['config']['sysmon']['gc_ms_limit'] = 50 #if gc takes longer than 50ms. Spam the log. 
	node['riak']['config']['sysmon']['heap_word_limit'] = 10485760
	
Index Merge
-----------
	node['riak']['config']['merge_index']['data_root'] = "/var/lib/riak/merge_index".to_erl_string
	node['riak']['config']['merge_index']['buffer_rollover_size'] = 1048576
	node['riak']['config']['merge_index']['max_compact_segments'] = 20
Notes
-----
The Chef 10.10 release has a [bug][5] where changes to a file resource does not properly notify restart. This is fixed in Chef 10.12.



[1]: http://basho.com/
[2]: http://wiki.basho.com/Bitcask 
[3]: http://wiki.basho.com/LevelDB.html
[4]: https://github.com/basho/lager
[5]: http://tickets.opscode.com/browse/CHEF-3125
[6]: https://github.com/basho/erlang_template_helper
