Vagrant.configure(2) do |config|
  config.vm.box = "chef/debian-7.7-i386"
  config.vm.box_check_update = false
  config.vm.network "forwarded_port", guest: 9000, host: 9000

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "256"
  end

  # See https://github.com/astorije/ansible-role-shout/issues/6
  config.vm.provision "shell", inline: <<-EOF
    sudo apt-get update
    sudo apt-get install -y supervisor
  EOF

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "tests/test.yml"
  end
end
