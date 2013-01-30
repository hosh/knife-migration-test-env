
# Must override this
default[:setup][:chef_server_version] = 'undefined'

default[:setup][:knife_dir] = '/vagrant/config'
default[:setup][:checksums_dir] = "#{default[:setup][:knife_dir]}/checksums"
default[:setup][:admin_name] = "admin"
default[:setup][:admin_key] = "admin.pem"
default[:setup][:admin_config] = "knife.rb"

case node[:setup][:chef_server_version]
when 'chef-10'
  # Use the webui to create an admin client for Chef 10
  default[:setup][:admin_keys] = '/etc/chef/validation.pem /etc/chef/webui.pem'
  default[:setup][:initial_admin] = 'chef-webui'
  default[:setup][:initial_admin_key] = "webui.pem"
  default[:setup][:initial_admin_config] = "webui-knife.rb"
  default[:setup][:validator_name] = 'chef-validator'
  default[:setup][:validator_key] = 'validation.pem'

  default[:setup][:chef_server_url] = 'http://33.33.33.210:4000'
when 'chef-11'
  # Use the admin user for Chef 11
  default[:setup][:admin_keys] = '/etc/chef-server/admin.pem /etc/chef-server/chef-validator.pem'
  default[:setup][:initial_admin] = 'admin'
  default[:setup][:initial_admin_key] = "#{node[:setup][:knife_dir]}/admin.pem"
  default[:setup][:validator_name] = 'chef-validator'
  default[:setup][:validator_key] = 'chef-validator.pem'
else
  fail "Define setup/chef_server_version"
end
