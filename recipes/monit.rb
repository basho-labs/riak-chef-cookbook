# This is an optional recipe that provides monit monitoring of your riak node. Requires the monit cookbook.

include_recipe "monit::default"

monitrc "riak" do
  variables(
    :process_matching => node['riak']['monit']['process_matching'],
    :start_program => node['riak']['monit']['start_program'],
    :http_host => node['riak']['monit']['http_host'],
    :http_port => node['riak']['monit']['http_port']
  )
  template_source "riak-monit.conf.erb"
  template_cookbook "riak"
end
