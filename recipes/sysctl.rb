# contains the bare minimum sysctl tunings to prevent
# riak from throwing warnings on startup
# This is optional for those with existing
# tuning or wrapper cookbooks

case node['platform_family']
when 'debian', 'rhel', 'fedora'
  node.default['sysctl']['params']['vm']['swappiness'] = 0
  node.default['sysctl']['params']['net']['core']['somaxconn'] = 40_000

  node.default['sysctl']['params']['net']['core'].tap do |core|
    core['somaxconn']          = 40_000
    core['wmem_default']       = 8_388_608
    core['wmem_max']           = 8_388_608
    core['rmem_default']       = 8_388_608
    core['rmem_max']           = 8_388_608
    core['netdev_max_backlog'] = 10_000
  end

  node.default['sysctl']['params']['net']['ipv4'].tap do |ipv4|
    ipv4['tcp_max_syn_backlog'] = 40_000
    ipv4['tcp_sack']            = 1
    ipv4['tcp_window_scaling']  = 1
    ipv4['tcp_fin_timeout']     = 15
    ipv4['tcp_keepalive_intvl'] = 30
    ipv4['tcp_tw_reuse']        = 1
    ipv4['tcp_moderate_rcvbuf'] = 1
  end

  include_recipe 'sysctl::apply'
end
