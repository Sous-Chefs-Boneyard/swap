describe bash('grep /mnt/swap /etc/fstab | awk \'{ print $1 }\'') do
  its('stdout') { should match %r{\/mnt\/swap/} }
end
