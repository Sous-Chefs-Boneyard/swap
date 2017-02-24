describe bash('cat /etc/fstab') do
  its('stdout') { should match %r{\/mnt\/swap/} }
end
