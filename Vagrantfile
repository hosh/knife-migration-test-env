require 'berkshelf/vagrant'

Vagrant::Config.run do |config|
  # config.berkshelf.berksfile_path = "./Berksfile"
  # config.berkshelf.only = []
  # config.berkshelf.except = []

  config.vm.define :chef_10 do |c10|
    c10.vm.host_name = "chef-10"

    c10.vm.box = "opscode-ubuntu-10.04"
    c10.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/boxes/opscode-ubuntu-10.04.box"
    c10.vm.network :hostonly, "33.33.33.210"

    c10.vm.provision :chef_solo do |chef|
      chef.json = {
        'chef-server' =>
        {
          package_file: 'https://opscode-omnitruck-release.s3.amazonaws.com/ubuntu/10.04/x86_64/chef_10.18.2-2.ubuntu.10.04_amd64.deb'
        }
      }

      chef.run_list = [ "chef-server" ]
    end
  end

  config.vm.define :chef_11 do |c11|
    c11.vm.host_name = "chef-11"

    c11.vm.box = "opscode-ubuntu-10.04"
    c11.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/boxes/opscode-ubuntu-10.04.box"
    c11.vm.network :hostonly, "33.33.33.211"

    c11.vm.provision :chef_solo do |chef|
      chef.json = {
        'chef-server' => { version: :latest, prerelease: true, nightlies: true }
      }

      chef.run_list = [ "chef-server" ]
    end
  end

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  # config.vm.share_folder "v-data", "/vagrant_data", "../data"

  config.ssh.max_tries = 40
  config.ssh.timeout   = 120
end
