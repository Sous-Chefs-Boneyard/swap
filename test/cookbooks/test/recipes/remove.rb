swap_file 'create prior to the delete' do
  path '/mnt/swap'
  size 1
end

swap_file '/mnt/swap' do
  action :remove
end
