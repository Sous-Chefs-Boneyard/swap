describe file('/mnt/swap') do
  it { should exist }
end

describe bash('ls -l --block-size=M /mnt') do
  its('stdout') { should match /1M/ }
end

describe bash('grep 10 /proc/sys/vm/swappiness') do
  its('stdout') { should match /10/ }
end
