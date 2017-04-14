default['swap']['mountpoint'] = '/var/swapfile'
default['swap']['size'] = (node['memory']['total'].to_i / 1024) * 2
