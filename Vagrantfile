# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "generic/centos8s"

  config.vm.provider "virtualbox" do |v|
    v.memory = 256
    v.cpus = 1
  end

  config.vm.define "repo" do |repo|
    repo.vm.network "private_network", ip: "192.168.56.150", virtualbox__intnet: "internal"
    repo.vm.network "forwarded_port", guest: 80, host: 8080
    repo.vm.hostname = "repo"
    repo.vm.provision "shell", path: "repo.sh"
  end
  
end
