require 'mixlib/config'

module Environment
  class Config
    extend Mixlib::Config

    chef_10_ip_addr '33.33.33.210'
    chef_11_ip_addr '33.33.33.211'

    base_box     "opscode-ubuntu-12.04"
    base_box_url "https://opscode-vm.s3.amazonaws.com/vagrant/boxes/opscode-ubuntu-12.04.box"
  end
end
