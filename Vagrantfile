Vagrant::Config.run do |config|

  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.provision :chef_solo do |chef|

    chef.log_level = "debug"

    chef.run_list = [
      "recipe[swap::test]"
    ]
  end
end
