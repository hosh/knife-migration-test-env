namespace :run do
  namespace :chef_10 do
    desc "Set up Chef 10 test run"
    task :setup do
      puts "[chef-10] Setting up run directory"
      Run.shell_out! "mkdir -p run/chef-10"
    end

    desc "Wipe Chef 10 run data"
    task :wipe do
      puts "[chef-10] Wiping run directory"
      Run.shell_out! "rm -fr run/chef-10"
    end

    desc "Runs Chef 10 tests without cleaning"
    task run: [ 'vm:chef_10:upload', 'vm:chef_10:download' ]

    desc "Runs Chef 10 tests after wiping test data"
    task clean_run: [ :wipe, :setup, :run ]

    desc "Rebuilds VMs and runs tests from scratch"
    task complete_run: [ 'vm:chef_10:rebuild', :clean_run ]
  end
end