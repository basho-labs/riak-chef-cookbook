This cookbook includes support for running tests via Test Kitchen. This has
some requirements:

1. You must be using the Git repository, rather than the downloaded cookbook
   from the Chef Community Site.
2. You must have Vagrant 1.1+ installed.
3. You must have a Ruby 1.9.3+ environment.

Once the above requirements are met, install the additional requirements:

Install the Berkshelf plugin for Vagrant, and Berkshelf to your local Ruby
environment:

```bash
$ vagrant plugin install vagrant-berkshelf
$ gem install berkshelf
```

Install Test Kitchen:

```bash
gem install test-kitchen --pre
```

Install the Vagrant driver for Test Kitchen:

```bash
gem install kitchen-vagrant
```

Once the above are installed, you should be able to run Test Kitchen:

```bash
kitchen list
kitchen test
```
