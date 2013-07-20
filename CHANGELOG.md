## v2.2.1:

* Fixed package installation so that it respects version numbers.

## v2.2.0:

* Riak `1.4.0` is the default.
* Debian init scripts now use `start-stop-daemon` for `start`. This caused an
  issue with the way we were handling file descriptor limits for Debian. Now
  the init script sources `/etc/default/riak`, which contains the appropriate
  `ulimit` call.
* Added new options and defaults to `vm.args` and `app.config` attributes.
* Test Kitchen requires version `2.2.4` or greater of the `yum` cookbook
  because earlier versions contained a bad test stub.
