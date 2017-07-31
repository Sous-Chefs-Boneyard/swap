require 'spec_helper'

describe 'create test recipe on ubuntu 16.04' do
  let(:runner) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04') }
  let(:chef_run) { runner.converge('test::create') }

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end
end

describe 'persist test recipe on ubuntu 16.04' do
  let(:runner) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04') }
  let(:chef_run) { runner.converge('test::persist') }

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end
end

describe 'remove test recipe on ubuntu 16.04' do
  let(:runner) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04') }
  let(:chef_run) { runner.converge('test::remove') }

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end
end

describe 'create_swappiness test recipe on ubuntu 16.04' do
  let(:runner) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04') }
  let(:chef_run) { runner.converge('test::create_swappiness') }

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end
end
