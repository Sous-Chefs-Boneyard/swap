# Test recipe for use with vagrant

swap_file "/swapfile" do
  action :create
  size 1024
end

swap_file "/swapfile" do
  action :remove
  size 1024
end