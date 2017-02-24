describe bash('cat /etc/fstab') do
  its('stdout') { should_not match /\/mnt\/swap/ }
end
