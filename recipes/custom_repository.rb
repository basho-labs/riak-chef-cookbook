version_str = "#{node['riak']['package']['version']['major']}.#{node['riak']['package']['version']['minor']}"
package_version = "#{version_str}.#{node['riak']['package']['version']['incremental']}-#{node['riak']['package']['version']['build']}"

package "riak" do
  action :install
  version package_version
end
