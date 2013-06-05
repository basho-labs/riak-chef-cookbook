default['riak']['monit']['process_matching'] = "#{node['riak']['data_dir']}/erts-5.8.5/bin/beam.smp"
default['riak']['monit']['start_program'] = "#{node['riak']['bin_dir']}/riak"
default['riak']['monit']['http_host'] = "localhost"
default['riak']['monit']['http_port'] = "8098"
