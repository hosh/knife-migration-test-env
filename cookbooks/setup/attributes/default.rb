
# Must override this
default[:setup][:chef_server_version] = 'undefined'

default[:setup][:knife_dir] = '/vagrant/config'

case node[:setup][:chef_server_version]
when 'chef-10'
  default[:setup][:admin_keys] = '/etc/chef/validation.pem /etc/chef/webui.pem'
when 'chef-11'
  default[:setup][:admin_keys] = '/etc/chef-server/admin.pem'
else
  fail "Define setup/chef_server_version"
end
