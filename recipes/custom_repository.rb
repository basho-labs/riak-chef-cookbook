version_str = "#{node['riak']['package']['version']['major']}.#{node['riak']['package']['version']['minor']}"
package_version = "#{version_str}.#{node['riak']['package']['version']['incremental']}-#{node['riak']['package']['version']['build']}"
platform_version = node['platform_version'].to_i

if node['platform_family'] == "rhel"
  if node['kernel']['machine'] == "x86_64"
    lib_dir = "/usr/lib64/riak"

    node.set['riak']['lib_dir'] = lib_dir
    node.set['riak']['config']['riak_core']['platform_lib_dir'] = lib_dir.to_erl_string
  end

  if platform_version >= 6
    package_version = "#{package_version}.el#{platform_version}"
  end
end

package node['riak']['package']['name'] do
  action :install
  version package_version
end
