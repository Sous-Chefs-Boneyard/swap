require 'berkshelf/vagrant'

Vagrant::Config.run do |config|
  config.vm.box = "Yipit12.04.1-10.16.4" 
  
  config.vm.provision :chef_solo do |chef|
    chef.log_level = "debug"
    chef.run_list = ["recipe[swap::test]"]
  end
end
