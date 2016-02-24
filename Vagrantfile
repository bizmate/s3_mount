# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    # Workaround for mitchellh/vagrant#1867
    # see https://groups.google.com/forum/#!topic/vagrant-up/XIxGdm78s4I
    if ARGV[1] and \
     (ARGV[1].split('=')[0] == "--provider" or ARGV[2])
    provider = (ARGV[1].split('=')[1] || ARGV[2])
    else
        provider = (ENV['VAGRANT_DEFAULT_PROVIDER'] || :virtualbox).to_sym
    end

    # Use image ubuntu 12.04 LTS
    config.vm.box = "ubuntu/precise64"

    config.vm.hostname = "Dev-S3Mount"
    config.vm.network :private_network, ip: "192.168.53.70"
    config.ssh.forward_agent = true
    config.vm.synced_folder "./", "/tmp/vagrant"

    puts "Running S3 mount install with provider: #{provider}"

    config.vm.provision "shell",
        inline: "/bin/bash /tmp/vagrant/provision/bootstrap.sh AWS_S3_KEY=MyKey AWS_S3_SECRET=MySecret AWS_S3_BUCKET=MyBucket"
end