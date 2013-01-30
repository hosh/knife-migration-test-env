
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
