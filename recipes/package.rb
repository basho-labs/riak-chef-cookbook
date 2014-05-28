#
# Author:: Benjamin Black (<b@b3k.us>), Sean Cribbs (<sean@basho.com>),
# Seth Thomas (<sthomas@basho.com>), and Hector Castro (<hector@basho.com>)
# Cookbook Name:: riak Recipe:: package
#
# Copyright (c) 2014 Basho Technologies, Inc.
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
unless node["riak"]["package"]["local"]["filename"].empty?
  package_file = node["riak"]["package"]["local"]["filename"]

  package node["riak"]["package"]["name"] do
    source "#{Chef::Config[:file_cache_path]}/#{package_file}"
    action :install
    options "--force-confdef --force-confold" if node["platform_family"] == "debian"
    provider value_for_platform_family(
      [ "debian" ] => Chef::Provider::Package::Dpkg,
      [ "rhel", "fedora" ] => Chef::Provider::Package::Rpm
    )
    only_if do
      ::File.exists?("#{Chef::Config[:file_cache_path]}/#{package_file}") &&
        Digest::SHA256.file("#{Chef::Config[:file_cache_path]}/#{package_file}").hexdigest == node["riak"]["package"]["local"]["checksum"]
    end
  end
else
  version_str = [ "major", "minor", "incremental" ].map { |ver| node["riak"]["package"]["version"][ver] }.join(".")
  base_uri = "#{node["riak"]["package"]["url"]}/#{node["riak"]["package"]["version"]["major"]}.#{node["riak"]["package"]["version"]["minor"]}/#{version_str}/"
  base_filename = "riak-#{version_str}"
  platform_version = node["platform_version"].to_i
  package_version = "#{version_str}-#{node["riak"]["package"]["version"]["build"]}"

  case node["platform"]
  when "ubuntu", "debian"
    apt_repository "basho" do
      uri "http://apt.basho.com"
      distribution node["lsb"]["codename"]
      components ["main"]
      key "http://apt.basho.com/gpg/basho.apt.key"
    end

    if node["platform"] == "ubuntu" && package_version == "1.3.2-1"
      package_version = package_version.gsub(/-/, "~precise")
    end

    package "riak" do
      action :install
      version package_version
    end
  when "centos", "redhat", "amazon"
    if node["platform"] == "amazon" && platform_version >= 2013
      platform_version = 6
    elsif node["platform"] == "amazon"
      platform_version = 5
    end

    yum_repository "basho" do
      description "Basho Stable Repo"
      url "http://yum.basho.com/el/#{platform_version}/products/x86_64/"
      gpgkey "http://yum.basho.com/gpg/RPM-GPG-KEY-basho"
      action :add
    end

    if platform_version >= 6
      package_version = "#{package_version}.el#{platform_version}"
    end

    package "riak" do
      action :install
      version package_version
    end
  when "fedora"
    base_uri = "#{base_uri}#{node["platform"]}/#{platform_version}/"
    package_file = "#{base_filename}-#{node["riak"]["package"]["version"]["build"]}.fc#{platform_version}.#{node["kernel"]["machine"]}.rpm"
    package_uri = base_uri + package_file

    remote_file "#{Chef::Config[:file_cache_path]}/#{package_file}" do
      source package_uri
      owner "root"
      mode 0644
      checksum node["riak"]["package"]["local"]["checksum"]
      action :create_if_missing
    end

    package "riak" do
      source "#{Chef::Config[:file_cache_path]}/#{package_file}"
      action :install
    end
  end
end
