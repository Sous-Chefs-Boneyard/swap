describe bash('cat /etc/fstab') do
  its('stdout') { should match /\/mnt\/swap/}
end
