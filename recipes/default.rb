#
# Author:: Benjamin Black (<b@b3k.us>) and Sean Cribbs (<sean@basho.com>)
# Cookbook Name:: riak
# Recipe:: default
#
# Copyright (c) 2011 Basho Technologies, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "riak::config"

if node[:riak][:package][:url]
  package_uri = node[:riak][:package][:url]
  package_file = package_uri.split("/").last
else
  version_str = "#{node[:riak][:package][:version][:major]}.#{node[:riak][:package][:version][:minor]}"
  base_uri = "http://downloads.basho.com/riak/riak-#{version_str}.#{node[:riak][:package][:version][:incremental]}/"
  base_filename = "riak-#{version_str}.#{node[:riak][:package][:version][:incremental]}"


  case node[:platform]
  when "debian","ubuntu"
    machines = {"x86_64" => "amd64", "i386" => "i386", "i686" => "i386"}
  when "redhat","centos","scientific","fedora","suse"
    machines = {"x86_64" => "x86_64", "i386" => "i386", "i686" => "i686"}
  end
  package_file =  case node[:riak][:package][:type]
                  when "binary"
                    case node[:platform]
                    when "debian","ubuntu"
                      if node[:platform_version] == "11.10"
                        "#{base_filename.gsub(/\-/, '_')}-#{node[:riak][:package][:version][:build]}_ubuntu_11_#{machines[node[:kernel][:machine]]}.deb"
                      else
                        "#{base_filename.gsub(/\-/, '_')}-#{node[:riak][:package][:version][:build]}_#{machines[node[:kernel][:machine]]}.deb"
                      end
                    when "centos","redhat","suse"
                      if node[:platform_version].to_i == 6
                        "#{base_filename}-#{node[:riak][:package][:version][:build]}.el6.#{machines[node[:kernel][:machine]]}.rpm"
                      else
                        "#{base_filename}-#{node[:riak][:package][:version][:build]}.el5.#{machines[node[:kernel][:machine]]}.rpm"
                      end
                    when "fedora"
                      "#{base_filename}-#{node[:riak][:package][:version][:build]}.fc13.#{node[:kernel][:machine]}.rpm"
                    end
                  when "source"
                    "#{base_filename}.tar.gz"
                  end
  package_uri = base_uri + package_file
end

package_name = package_file.split("[-_]\d+\.").first

#if %w{debian ubuntu}.include?(node[:platform])
#  include_recipe "riak::iptables"
#end

group "riak"

user "riak" do
  gid "riak"
  shell "/bin/bash"
  home "/var/lib/riak"
  system true
end

directory "/tmp/riak_pkg" do
  owner "root"
  mode 0755
  action :create
end

remote_file "/tmp/riak_pkg/#{package_file}" do
  source package_uri
  owner "root"
  mode 0644
  checksum node[:riak][:package][:source_checksum]
  not_if { File.exists?("/tmp/riak_pkg/#{package_file}") }
end

case node[:riak][:package][:type]
when "binary"
  package package_name do
    source "/tmp/riak_pkg/#{package_file}"
    action :install
    provider value_for_platform(
      [ "ubuntu", "debian" ] => {"default" => Chef::Provider::Package::Dpkg},
      [ "redhat", "centos", "fedora", "suse" ] => {"default" => Chef::Provider::Package::Rpm}
    )
  end
when "source"
  execute "riak-src-unpack" do
    cwd "/tmp/riak_pkg"
    command "tar xvfz #{package_file}"
  end

  execute "riak-src-build" do
    cwd "/tmp/riak_pkg/#{base_filename}"
    command "make clean all rel"
  end

  execute "riak-src-install" do
    command "mv /tmp/riak_pkg/#{base_filename}/rel/riak #{node[:riak][:package][:prefix]}"
    not_if { File.directory?("#{node[:riak][:package][:prefix]}/riak") }
  end
end

case node[:riak][:kv][:storage_backend]
when :riak_kv_innostore_backend
  include_recipe "riak::innostore"
end

directory node[:riak][:package][:config_dir] do
  owner "root"
  mode "0755"
  action :create
end

template "#{node[:riak][:package][:config_dir]}/app.config" do
  source "app.config.erb"
  owner "root"
  mode 0644
end

template "#{node[:riak][:package][:config_dir]}/vm.args" do
  variables :switches => prepare_vm_args(node[:riak][:erlang])
  source "vm.args.erb"
  owner "root"
  mode 0644
end

if node[:riak][:package][:type].eql?("binary")
  service "riak" do
    supports :start => true, :stop => true, :restart => true
    action [ :enable ]
    subscribes :restart, resources(:template => [ "#{node[:riak][:package][:config_dir]}/app.config",
                                   "#{node[:riak][:package][:config_dir]}/vm.args" ])
  end
end
