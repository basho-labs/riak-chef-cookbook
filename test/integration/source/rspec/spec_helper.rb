 require 'serverspec'

 # Required by serverspec
 set :backend, :exec

 set :path, '/sbin:/usr/local/sbin:$PATH'

 set :formatter, :documentation
