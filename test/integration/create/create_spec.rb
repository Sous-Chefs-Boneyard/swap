describe file('/mnt/swap') do
  it { should exist }
end

describe bash('ls -l --block-size=M /mnt') do
  its('stdout') { should match /1M/ }
end
