require 'vm'

namespace :vm do
  desc "Rebuilds all VMs"
  task :rebuild => [ 'vm:chef_10:rebuild', 'vm:chef_11:rebuild' ]

  namespace :chef_10 do
    desc "Brings up the Chef 10 server"
    task :up do
      puts "\n[chef-10] Building and starting Chef 10 server\n"
      Chef(10).vagrant! "up"
    end

    desc "Destroys the Chef 10 server"
    task :destroy do
      puts "\n[chef-10] Taking down Chef 10 server\n"
      Chef(10).vagrant! "destroy -f"
      Chef(10).shell_out! "rm -fr config/"
    end

    desc "Rebuilds the Chef 10 server"
    task :rebuild => [ :destroy, :up ] do
      puts "[chef-11]Done."
    end

    desc "Uploads test repo to the Chef 10 server"
    task :upload do
      puts "\n[chef-10] Uploading test data to server"
      Chef(10).bundle_exec! "knife upload / --chef-repo-path ../run/data/ -c config/knife.rb --repo-mode full"
    end

    desc "Downloads test repo to the Chef 10 server"
    task download: [ 'run:chef_10:setup' ] do
      puts "\n[chef-10] Downloading test data to server"
      Chef(10).bundle_exec! "knife download / --chef-repo-path ../run/chef-10 -c config/knife.rb --repo-mode full"
    end
  end

  namespace :chef_11 do
    desc "Brings up the Chef 11 server"
    task :up do
      puts "\n[chef-11] Building and starting Chef 11 server\n"
      Chef(11).vagrant! "up"
    end

    desc "Destroys the Chef 11 server"
    task :destroy do
      puts "\n[chef-11] Taking down Chef 11 server\n"
      Chef(11).vagrant! "destroy -f"
      Chef(11).shell_out! "rm -fr config/"
    end

    desc "Rebuilds the Chef 11 server"
    task :rebuild => [ :destroy, :up ] do
      puts "[chef-11] Done."
    end
  end
end
