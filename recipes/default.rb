# Default recipe to add a swap file
# Set node['swap']['mountpoint'] and node['swap']['size']
# Or leave the default '/var/swapfile' and twice the amount of RAM detected

swap_file node['swap']['mountpoint'] do
  size node['swap']['size']
end
