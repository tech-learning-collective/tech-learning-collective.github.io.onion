# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vagrant.plugins = "vagrant-docker-compose"

  config.vm.box = "ubuntu/bionic64"

  config.vm.provision "shell", inline: "apt-get update"
  config.vm.provision "docker" # Just install Docker.
  config.vm.provision "docker_compose",
    compose_version: "1.29.2",
    yml: ["/vagrant/docker-compose.yaml"]
end
