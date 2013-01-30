
directory node[:setup][:knife_dir] do
  recursive true
  action :create
end

# Always copy the file
execute "copy master key files" do
  command "cp #{node[:setup][:admin_keys]} #{node[:setup][:knife_dir]}"
end
