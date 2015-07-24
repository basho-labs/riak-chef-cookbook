# riak
[![Cookbook Version](http://img.shields.io/cookbook/v/riak.svg)][cookbook]
[![Build Status](http://img.shields.io/travis/basho-labs/riak-chef-cookbook.svg)][travis]

[cookbook]: https://supermarket.chef.io/cookbooks/riak
[travis]: http://travis-ci.org/basho-labs/riak-chef-cookbook

## Description

[Riak](http://basho.com/riak/) is an open source, distributed database that focuses on high availability, horizontal scalability, and *predictable* latency.

This repository is **community supported**. We both appreciate and need your contribution to keep it stable. For more on how to contribute, [take a look at the contribution process](#contribution).

Thank you for being part of the community! We love you for it.

## Requirements

* Chef 11 or higher

## Platform Support

* Ubuntu 14.04
* Ubuntu 12.04
* Debian 7.8
* CentOS 7.1
* CentOS 6.6
* CentOS 5.11
* FreeBSD 10.1
* FreeBSD 9.3

## Cookbook Dependencies

* apt
* build-essential
* erlang
* git
* java
* sysctl
* ulimit
* yum
* yum-epel

## Attributes

* `node['riak']['install_method']` - Method to install Riak (`package`,
  `enterprise_package`, `source`, `custom_repository`)
* `node['riak']['platform_bin_dir']` - Base directory for binaries.
* `node['riak']['platform_data_dir']` - Base directory for data files.
* `node['riak']['platform_etc_dir']` - Base directory for configuration files.
* `node['riak']['platform_log_dir']` - Base directory for log files.
* `node['riak']['platform_lib_dir']` - Base directory for libraries.
* `node['riak']['patches']` - List of patches to apply by placing in the
  `basho-patches` directory.
* `node['riak']['config']['log.console']` - Where to emit the default log
  messages (`off`, `file`, `console`, `both`).
* `node['riak']['config']['log']['console']['level']` - Severity level of the
  console log (`ebug`, `info`, `warning`, `error`).
* `node['riak']['config']['log']['console']['file']` - When
  `node['riak']['config']['log.console']` is set to `file` or `both`, the file
  where console messages will be logged.
* `node['riak']['config']['log']['error']['file']` - The file where error
  messages will be logged.
* `node['riak']['config']['log']['syslog']` - Enables log output to syslog
  (`on`, `off`).
* `node['riak']['config']['log.crash']` - Whether to enable the crash log (`on`, `off`).
* `node['riak']['config']['log']['crash']['file']` - The file where its
  messages will be written.
* `node['riak']['config']['log']['crash']['maximum_message_size']` - Maximum
  size (in bytes) of individual messages in the crash log.
* `node['riak']['config']['log']['crash']['size']` - Maximum size of the crash
  log (in bytes), before it is rotated.
* `node['riak']['config']['log']['crash.rotation']` - The schedule on which to
  rotate the crash log. See
  [here](https://github.com/basho/lager/blob/master/README.md#internal-log-rotation)
  for details.
* `node['riak']['config']['log']['crash']['rotation']['keep']` - The number of
  rotated crash logs to keep.
* `node['riak']['config']['nodename']` - Name of the Erlang node.
* `node['riak']['config']['distributed_cookie']` - Cookie for distributed node
  communication.
* `node['riak']['config']['erlang']['async_threads']` - Number of threads in
  async thread pool (`0`-`1024`).
* `node['riak']['config']['erlang']['max_ports']` - Number of concurrent
  ports/sockets (`1024`-`134217727`).
* `node['riak']['config']['ring_size']` - Number of partitions in the cluster
  (must be a power of 2).
* `node['riak']['config']['transfer_limit']` - Number of concurrent node-to-
  node transfers allowed.
* `node['riak']['config']['ring']['state_dir']` - Location of ring state.
* `node['riak']['config']['ssl']['certfile']` - Default certificate location
  for HTTPS.
* `node['riak']['config']['ssl']['keyfile']` - Default key location for HTTPS.
* `node['riak']['config']['ssl']['cacertfile']` - Default signing authority
  for HTTPS.
* `node['riak']['config']['dtrace']` - Enable DTrace (`on`, `off`).
* `node['riak']['config']['strong_consistency']` - Enable consensus subsystem (`on`, `off`).
* `node['riak']['config']['listener']['http']['internal']` - IP address and
  TCP port that the Riak HTTP interface will bind to.
* `node['riak']['config']['listener']['protobuf']['internal']` - IP address
  and TCP port that the Riak Protocol Buffers interface will bind to.
* `node['riak']['config']['protobuf']['backlog']` - Maximum length of pending
  connections queue.
* `node['riak']['config']['listener']['https']['internal']` - IP address and
  TCP port that the Riak HTTPS interface will bind to.
* `node['riak']['config']['anti_entropy']` - Strategy of repairing out-of-sync
  keys (`active`, `passive`, `active-debug`).
* `node['riak']['config']['storage_backend']` - Storage backend for Riak's
  key-value and secondary index data (`bitcask`, `leveldb`, `memory`,
  `multi`).
* `node['riak']['config']['object']['format']` - Binary representation of a
  Riak value stored on disk (`0`, `1`).
* `node['riak']['config']['metadata_cache_size']` - Size of the metadata cache
  for each vnode.
* `node['riak']['config']['object']['size']['warning_threshold']` - Reading or
  writing objects larger than this size will write a warning in the logs.
* `node['riak']['config']['object']['size']['maximum']` - Writing an object
  larger than this will send a failure to the client.
* `node['riak']['config']['object']['siblings']['warning_threshold']` -
  Writing an object with more than this number of siblings will generate a
  warning in the logs.
* `node['riak']['config']['object']['siblings']['maximum']` - Writing an
  object with more than this number of siblings will send a failure to the
  client.
* `node['riak']['config']['bitcask']['data_root']` - A path under which
  Bitcask data files will be stored.
* `node['riak']['config']['bitcask']['io_mode']` - How Bitcask writes to disk
  (`erlang`, `nif`).
* `node['riak']['config']['riak_control.top_level']` - Enable administrative
  UI (`on`, `off`).
* `node['riak']['config']['riak_control']['auth']['mode']` - Authentication
  mode used for access to the administrative panel.
* `node['riak']['config']['riak_control']['auth']['user']['user']['password']`
  - List of usernames and passwords for access to Riak Control.
* `node['riak']['config']['leveldb']['data_root']` - A path under which
  LevelDB data files will be stored.
* `node['riak']['config']['leveldb']['maximum_memory']['percent']` -
  Percentage of total server memory to assign to LevelDB.
* `node['riak']['config']['leveldb']['compaction']['trigger']['tombstone_count']`
  - Controls when background LevelDB compaction initiates.
* `node['riak']['config']['jmx']` - Enable JMX monitoring output (`on`,
  `off`).
* `node['riak']['config']['search.top_level']` - Enable Riak Search (`on`,
  `off`).
* `node['riak']['config']['search']['solr']['start_timeout']` - How long Riak
  will wait for Solr to start.
* `node['riak']['config']['search']['solr']['port']` - Port number Solr will
  bind to.
* `node['riak']['config']['search']['solr']['jmx_port']` - Port number which
  Solr JMX binds to.
* `node['riak']['config']['search']['solr']['jvm_options']` - Options to pass
  to the Solr JVM.
* `node['riak']['config']['search']['anti_entropy']['data_dir']` - Path where
  Riak Search's Active Anti-Entropy data files will reside.
* `node['riak']['config']['search']['root_dir']` - Path for Riak Search index
  data.

### Package

* `node['riak']['package']['enterprise_key']` - Riak Enterprise key.
* `node['riak']['package']['version']['major']` - Major version number.
* `node['riak']['package']['version']['minor']` - Minor version number.
* `node['riak']['package']['version']['incremental']` - Incremental version number.
* `node['riak']['package']['version']['build']` - Build version number.
* `node['riak']['package']['local']['checksum']` - Checksum for local Riak
  package.

### Source

* `node['riak']['source']['url']` - Base path for downloading Riak source
  tarballs.
* `node['riak']['source']['version']['major']`- Major version number.
* `node['riak']['source']['version']['minor']` - Minor version number.
* `node['riak']['source']['version']['incremental']` - Incremental version
  number.
* `node['riak']['source']['prefix']` - Installation prefix for source install.
* `node['riak']['source']['checksum']` - Checksum for source tarball.

### ulimit

* `node['riak']['limits']['nofile']` - File descriptor limit for user running the Riak service

### sysctl

* `node['riak']['sysctl']['vm']['swappiness']`
* `node['riak']['sysctl']['net']['core']['somaxconn']`
* `node['riak']['sysctl']['net']['ipv4']['tcp_max_syn_backlog']`
* `node['riak']['sysctl']['net']['ipv4']['tcp_sack']`
* `node['riak']['sysctl']['net']['ipv4']['tcp_window_scaling']`
* `node['riak']['sysctl']['net']['ipv4']['tcp_fin_timeout']`
* `node['riak']['sysctl']['net']['ipv4']['tcp_keepalive_intvl']`
* `node['riak']['sysctl']['net']['ipv4']['tcp_tw_reuse']`
* `node['riak']['sysctl']['net']['ipv4']['tcp_moderate_rcvbuf']`

### Java

* `node['riak']['manage_java']` - Installs and configures Java.

**NOTE**: If `node['riak']['config']['search.top_level']` is set to `on` then Java must be
        installed beforehand (either by another recipe or this one) or Riak will fail to start

**NOTE**: As OpenJDK isn't supported officially and Sun Java for FreeBSD is only 32bit this recipe
          doesn't work/isn't tested on FreeBSD.

## Usage

### Attributes

You may notice that some attribute names contain `.top_level`. This is to aid
rendering special configuration settings that have other settings nested
beneath them.

A quick example:

`search` is a setting, but it also has `search.solr.start_timeout` and
`search.solr.port` beneath it:

```ruby
default['riak']['config']['search.top_level'] = 'off'
default['riak']['config']['search']['solr']['start_timeout'] = '30s'
default['riak']['config']['search']['solr']['port'] = 8093
```

These attributes render as:

```
search = off
search.solr.start_timeout = 30s
search.solr.port = 8093
```

### Installation Methods

There are several installation methods for Riak supported by this cookbook.
All require that the node's `run_list` contain the default `riak` recipe.

For more precise examples, please see the `.kitchen.yml` file.

#### Package

This is the default method of installation. Ensure that
`node['riak']['install_method']` is set to `package`.

#### Enterprise Package

For Riak Enterprise users, installing the Enterprise package requires setting
one attribute:

```ruby
default['riak']['package']['enterprise_key'] = '*******'
```

#### Custom Package

If you want to install a custom package of Riak (that isn't available in your
operating system's package repository), ensure that the following attributes
are set appropriately:

```ruby
default['riak']['install_method'] = 'custom_package'
default['riak']['package']['local']['checksum'] = '2b28aeabb21488125b7e39f768c8f3b98ac816d1a30c0d618c9f82f99e6e89d9'
default['riak']['package']['local']['url'] = 'http://s3.amazonaws.com/downloads.basho.com/riak/2.1/2.1.1/ubuntu/trusty'
```

**NOTE**: FreeBSD uses custom_package regardless.

#### Custom Repository

If you have a package repository setup on your operating system (that isn't
Basho's) and want to install Riak from there, ensure that
`node['riak']['install_method']` is set to `custom_repository`.

**NOTE**: This will fail unless the package repository is configured beforehand (earlier in run_list)

#### Source

If you want to install Riak (and Erlang) from source, ensure that
`node['riak']['install_method']` is set to `source`.


### Optional Recipes

#### riak::sysctl

This is an optional recipe to set sysctl tunings such that Riak will not emit warnings to the log.
As other systems or cookbooks may already configure these tunings, this recipe is optional. It should be placed
in the run_list before `recipe['riak']` if desired.

##Contributions

Basho Labs repos survive because of community contribution. Here’s how to get started.

* Fork the appropriate sub-projects that are affected by your change
* Create a topic branch for your change and checkout that branch
   `git checkout -b some-topic-branch`
* Make your changes and run the test suite if one is provided (see below)
* Commit your changes and push them to your fork
* Open a pull request for the appropriate project
* Contributors will review your pull request, suggest changes, and merge it when it’s ready and/or offer feedback
* To report a bug or issue, please open a new issue against this repository

### Maintainers
* Seth Thomas ([GitHub](https://github.com/cheeseplus))
* and You! [Read up](https://github.com/basho-labs/the-riak-community/blob/master/config-mgmt-strategy.md) and get involved

You can [read the full guidelines](http://docs.basho.com/riak/latest/community/bugs/) for bug reporting and code contributions on the Riak Docs. And **thank you!** Your contribution is incredibly important to us.

## License and Authors

* Author: Benjamin Black ([GitHub](https://github.com/b))
* Author: Sean Carey ([GitHub](https://github.com/densone))
* Author: Hector Castro ([GitHub](https://github.com/hectcastro))
* Author: Sean Cribbs ([GitHub](https://github.com/seancribbs))
* Author: Seth Thomas ([GitHub](https://github.com/cheeseplus))

Copyright (c) 2015 Basho Technologies, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
