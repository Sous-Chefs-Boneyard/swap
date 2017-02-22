swap_file '/mnt/swap' do
  size 1
end

swap_file '/mnt/swap' do
  action :remove
end
