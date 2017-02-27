## v3.1.4

* Fix URL location for new EE package locations

## v3.1.3

* Fix config content to be lazily evaluated

## v3.1.2

* Fix basho-patches directory

## v3.1.1

* Riak `2.1.1` is now the default
* Updated syctl tuning and made optional #169
* Relaxed dependency constraints #168
* Fixed building from source on Amazon #175

## v3.1.0

* Riak `2.0.5` is now the default
* Removal of `enterprise_package recipe`
* Removal of `custom_package recipe`
* All logic for the removed recipes moved to `package`
* Make Java install truely optional instead of based on config
* Remove extraneous attributes
* Checksums moved to attributes
* Cleaned up test-kitchen configs to refelct above changes
* FreeBSD support (finally)

## v3.0.2

* Riak `2.0.2` is now the default
* Updated build-essentials dependency

## v3.0.1

* Fixes enterprise package installs
* Passing all RuboCop checks
* Lots of small testing related fixes
* Pinning JDK version

## v3.0.0

* Riak `2.0.1` is now the default
* Add CentOS 7 Support
* Migrate to packagecloud.io repos

## v2.4.17

* Fix and update tests
* Add digitalocean to .kitchen.cloud.yml
* Add source build suite to .kitchen.cloud.yml

## v2.4.16

* If fqdn isn't valid, use ipaddress for vm.args -name
* Drop 13.10 support (EOL)
* Drop minitest for serverspec
* Update yum dependency which fixes https://github.com/opscode-cookbooks/yum/issues/99


## v2.4.15:

* Update Riak CS default version to 1.5.1

## v2.4.14:

* Riak `1.4.10` is now the default.
* Remove Ubuntu 13.04 support (EOL).
* Add Ubuntu 13.10 support
* Add Ubuntu 14.04 support

## v2.4.13:

* Increase pessimistic version constraint on `build-essential`.
* Restrict version constraint on `sysctl` due to breaking changes.

## v2.4.12:

* Increase default `ulimit` from `4096` to `65536`.

## v2.4.11:

* Ensure SNMP directory is created when customer `data_dir` is provided.

## v2.4.10:

* Fix invalid default Multi backend definitions.

## v2.4.9:

* Revert errant change of Riak node name from FQDN to IP address.

## v2.4.8:

* Make default for `cs_version` be `1.4.5`
* Add support for Ubuntu 13.04 (Raring).
* Add support for Amazon Linux (2014.03).

## v2.4.7:

* Ensure /etc/default/riak is regenerated when open file limits change.
* Ensure Riak data directory exists and is owned by the Riak user.
* Make all cookbook dependency versions explicit.

## v2.4.6:

* Updated yum dependency constraint.

## v2.4.5:

* Riak `1.4.8` is now the default.

## v2.4.4:

* Riak `1.4.7` is now the default.

## v2.4.3:

* Add a constraint to `yum` cookbook dependency so that breaking changes in
  v3.0 are mitigated.
* Updated Gemfile to include integration test dependencies.

## v2.4.2:

* Riak `1.4.6` is now the default.
* Make use of `vagrantfile_erb` setting of kitchen-vagrant.
* Added kernel and network tuning via sysctl.

## v2.4.1:

* Removed Recipe Tester.
* Bumped Chef to version `11.8.0` for Test Kitchen.
* Make default for `cs_version` be `1.4.3`

## v2.4.0:

* Added a recipe for installing Riak through a custom package repository.

## v2.3.4:

* Made Test Kitchen run faster by enabling the `vagrant-cachier` plugin
  through the `kitchen-vagrant` driver.
* Make default for `cs_version` be `1.4.1`

## v2.3.3:

* Riak `1.4.2` is now the default.
* Fixed the `remote_file` resource for Enterprise packages so that it utilizes
  a checksum.

## v2.3.2:

* Add a default `cluster_mgr` attribute.
* Add `allow_mult` override when the `riak_cs_kv_multi_backend` is chosen.

## v2.3.1:

* Riak `1.4.1` is now the default.
* Fixed Debian support.
* Added Debian Wheezy to Test Kitchen.

## v2.3.0:

* Fixed package installation so that it respects version numbers.
* Added Test Kitchen support for CentOS 5.9.
* Fixed Protocol Buffers interface configuration changes between Riak 1.3 and
  1.4.

## v2.2.0:

* Riak `1.4.0` is the default.
* Debian init scripts now use `start-stop-daemon` for `start`. This caused an
  issue with the way we were handling file descriptor limits for Debian. Now
  the init script sources `/etc/default/riak`, which contains the appropriate
  `ulimit` call.
* Added new options and defaults to `vm.args` and `app.config` attributes.
* Test Kitchen requires version `2.2.4` or greater of the `yum` cookbook
  because earlier versions contained a bad test stub.
