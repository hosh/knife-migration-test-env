
knife_dir    = node[:setup][:knife_dir]
admin_name   = node[:setup][:admin_name]
admin_key    = "#{knife_dir}/#{node[:setup][:admin_key]}"
knife_config = "#{knife_dir}/#{node[:setup][:initial_admin_config]}"

template knife_config do
  source 'knife.rb.erb'
  mode '0600'
  variables({
    name:               node[:setup][:initial_admin],
    key_file:           node[:setup][:initial_admin_key],
    chef_server_url:    node[:setup][:chef_server_url],
    validator_name:     node[:setup][:validator_name],
    validator_key_file: node[:setup][:validator_key]
  })
end

execute "knife client create #{admin_name} --admin --file #{admin_key} --disable-editing -c #{knife_config}" do
  creates admin_key
end
