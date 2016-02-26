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

    puts "Running install with provider: #{provider} "

    if provider == "digital_ocean"
        config.vm.provider :aws do |aws, override|
            aws.access_key_id = ENV["AWS_S3_ACCESS_KEY"]
            aws.secret_access_key = ENV["AWS_S3_ACCESS_SECRET"]
            aws.session_token = ENV["AWS_SESSION TOKEN"]
            aws.keypair_name = ENV["AWS_KEYPAIR_NAME"]
            aws.ami = ENV["AWS_AMI"]
            aws.security_groups = ENV["AWS_SECURITY_GROUP"]

            aws.instance_type = "t1.micro"
            aws.region = "eu-west-1"

            override.ssh.username = "ubuntu"
            override.ssh.private_key_path = ENV["AWS_SSH_PRIVATE_KEY_PATH"]
        end

    else
        config.vm.hostname = "Dev-S3Mount"
        config.vm.network :private_network, ip: "192.168.53.70"
        config.ssh.forward_agent = true
        config.vm.synced_folder "./", "/tmp/vagrant"
    end

    awsS3Key = ENV["AWS_S3_ACCESS_KEY"]
    awsS3Secret = ENV["AWS_S3_ACCESS_SECRET"]
    awsS3Bucket = ENV["AWS_S3_BUCKET"]

    puts "Running S3 mount install with provider: #{provider} KEY #{awsS3Key} SECRET #{awsS3Secret} on  Bucket #{awsS3Bucket}"
    config.vm.provision "shell",
        inline: "/bin/bash /tmp/vagrant/provision/bootstrap.sh AWS_S3_KEY=#{awsS3Key} AWS_S3_SECRET=#{awsS3Secret} AWS_S3_BUCKET=#{awsS3Bucket}"
end