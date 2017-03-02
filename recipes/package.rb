#
# Author:: Benjamin Black (<b@b3k.us>), Sean Cribbs (<sean@basho.com>),
# Seth Thomas (<sthomas@basho.com>), and Hector Castro (<hector@basho.com>)
# Cookbook Name:: riak
# Recipe:: package
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

oss_or_ee = node['riak']['package']['enterprise_key'].empty? ? 'riak' : 'riak-ee'
version_str = %w(major minor incremental).map { |ver| node['riak']['package']['version'][ver] }.join('.')
major_minor = %w(major minor).map { |ver| node['riak']['package']['version'][ver] }.join('.')
package_version = "#{version_str}-#{node['riak']['package']['version']['build']}"
install_method = node['platform'] == 'freebsd' || oss_or_ee == 'riak-ee' ? 'custom_package' : node['riak']['install_method']
plat_ver_int = node['platform_version'].to_i

# Enterprise download URL changed with release of 2.0.8 and greater
if Gem::Version.new(version_str) >= Gem::Version.new('2.0.8')
  ee_url_prefix = "http://private.downloads.basho.com/riak_ee/#{node['riak']['package']['enterprise_key']}/#{version_str}"
else
  ee_url_prefix = "http://private.downloads.basho.com/riak_ee/#{node['riak']['package']['enterprise_key']}/#{major_minor}/#{version_str}"
end

case  install_method
when 'package', 'custom_repository'
  case node['platform']
  when 'ubuntu', 'debian'
    packagecloud_repo 'basho/riak' do
      type 'deb'
      not_if { install_method == 'custom_repository' }
    end

  when 'centos', 'redhat', 'amazon', 'fedora'
    packagecloud_repo 'basho/riak' do
      type 'rpm'
      not_if { install_method == 'custom_repository' }
    end

    case plat_ver_int
    when 6, 2013, 2014
      package_version = "#{package_version}.el6"
    when 7
      package_version = "#{package_version}.el7.centos"
    when 19
      package_version = "#{package_version}.fc#{plat_ver_int}"
    end
  end

  package 'riak' do
    action :install
    version package_version
    options '-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"' \
            if node['platform_family'] == 'debian'
  end
when 'custom_package', 'enterprise_package'
  case node['platform']
  when 'debian'
    package_file = "#{oss_or_ee}_#{package_version}_amd64.deb"
    ee_url_suffix = "/debian/#{plat_ver_int}/#{package_file}"
    if Gem::Version.new(version_str) >= Gem::Version.new('2.2.0')
      ee_url_suffix = "/debian/#{node['lsb']['codename']}/#{package_file}"
    end
    if Gem::Version.new(version_str) >= Gem::Version.new('2.0.8') &&
       Gem::Version.new(version_str) < Gem::Version.new('2.1.0')
      ee_url_suffix = "/debian/#{node['lsb']['codename']}/#{package_file}"
    end
  when 'ubuntu'
    package_file = "#{oss_or_ee}_#{package_version}_amd64.deb"
    ee_url_suffix = "/ubuntu/#{node['lsb']['codename']}/#{package_file}"
  when 'centos', 'redhat'
    case plat_ver_int
    when 7
      package_file = "#{oss_or_ee}-#{package_version}.el7.centos.x86_64.rpm"
    when 5, 6
      package_file = "#{oss_or_ee}-#{package_version}.el#{plat_ver_int}.x86_64.rpm"
    end
    ee_url_suffix = "/rhel/#{plat_ver_int}/#{package_file}"
  when 'amazon'
    package_file = "#{oss_or_ee}-#{package_version}.el6.x86_64.rpm"
    ee_url_suffix = "/rhel/6/#{package_file}"
  when 'fedora'
    package_file = "#{oss_or_ee}-#{package_version}.fc#{plat_ver_int}.x86_64.rpm"
    ee_url_suffix = "/fedora/#{plat_ver_int}/#{package_file}"
  when 'freebsd'
    case plat_ver_int
    when 10
      package_file = "#{oss_or_ee}-#{version_str}.txz"
      ee_url_suffix = "/freebsd/10/#{package_file}"
    when 9
      package_file = "#{oss_or_ee}-#{version_str}-FreeBSD-amd64.tbz"
      ee_url_suffix = "/freebsd/9.2/#{package_file}"
    end
  end

  if node['riak']['package']['enterprise_key'].empty?
    checksum_val = node['riak']['package']['local']['checksum'][node['platform']][plat_ver_int.to_s]
    pkg_url = "#{node['riak']['package']['local']['url']}/#{package_file}"
  elsif node['riak']['package']['enterprise_key'].length > 0 && node['riak']['package']['local']['url'].length > 0
    checksum_val = node['riak']['package']['enterprise']['checksum'][node['platform']][plat_ver_int.to_s]
    pkg_url = "#{node['riak']['package']['local']['url']}/#{package_file}"
  else
    checksum_val = node['riak']['package']['enterprise']['checksum'][node['platform']][plat_ver_int.to_s]
    pkg_url = ee_url_prefix + ee_url_suffix
  end

  remote_file "#{Chef::Config[:file_cache_path]}/#{package_file}" do
    source pkg_url
    checksum checksum_val
    owner 'root'
    mode 0644
  end
  if node['platform'] == 'freebsd' && plat_ver_int == 9
    pkg_add 'riak' do
      location pkg_url
      action :install
    end
  else
    package oss_or_ee do
      source "#{Chef::Config[:file_cache_path]}/#{package_file}"
      action :install
      provider value_for_platform_family(
         %w(debian) => Chef::Provider::Package::Dpkg,
         %w(rhel fedora) => Chef::Provider::Package::Rpm)
      only_if do
        ::File.exist?("#{Chef::Config[:file_cache_path]}/#{package_file}") &&
          Digest::SHA256.file("#{Chef::Config[:file_cache_path]}/#{package_file}").hexdigest ==
            checksum_val
      end
    end
  end
end
