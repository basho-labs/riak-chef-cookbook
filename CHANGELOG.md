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
