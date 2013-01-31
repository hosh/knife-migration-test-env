require 'vm'

namespace :vm do
  namespace :chef_10 do
    desc "Brings up the Chef 10 server"
    task :up do
      Chef(10).vagrant! "up"
    end

    desc "Destroys the Chef 10 server"
    task :destroy do
      Chef(10).vagrant! "destroy -f"
      Chef(10).shell_out! "rm -fr config/"
    end

    desc "Rebuilds the Chef 10 server"
    task :rebuild => [ :destroy, :up ] do
      puts "Done."
    end
  end

  namespace :chef_11 do
    desc "Brings up the Chef 11 server"
    task :up do
      Chef(11).vagrant! "up"
    end

    desc "Destroys the Chef 11 server"
    task :destroy do
      Chef(11).vagrant! "destroy -f"
      Chef(11).shell_out! "rm -fr config/"
    end

    desc "Rebuilds the Chef 11 server"
    task :rebuild => [ :destroy, :up ] do
      puts "Done."
    end
  end
end
