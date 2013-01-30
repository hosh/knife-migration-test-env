
directory node[:setup][:knife_dir] do
  recursive true
  action :create
end

directory node[:setup][:checksums_dir] do
  recursive true
  action :create
end

# Always copy the file
execute "copy master key files" do
  command "cp #{node[:setup][:admin_keys]} #{node[:setup][:knife_dir]}"
end

# Chef 10 needs to create an admin other than webui
case node[:setup][:chef_server_version]
when 'chef-10'
  include_recipe 'setup::admin'
end

knife_dir    = node[:setup][:knife_dir]
knife_config = "#{knife_dir}/#{node[:setup][:admin_config]}"

template knife_config do
  source 'knife.rb.erb'
  mode '0600'
  variables({
    name:               node[:setup][:admin_name],
    key_file:           node[:setup][:admin_key],
    chef_server_url:    node[:setup][:chef_server_url],
    validator_name:     node[:setup][:validator_name],
    validator_key_file: node[:setup][:validator_key]
  })
end
