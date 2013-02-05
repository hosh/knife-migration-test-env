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

    desc "Verifies Chef 10 repo matches test data"
    task :verify do
      puts "[chef-10] Verifying migration integrity"
      Environment::Base.verify('run/data', 'run/chef-10')
    end

    desc "Runs Chef 10 tests without cleaning"
    task run: [ 'vm:chef_10:upload', 'vm:chef_10:download', :verify ]

    desc "Runs Chef 10 tests after wiping test data"
    task clean_run: [ :wipe, :setup, :run ]

    desc "Rebuilds VMs and runs tests from scratch"
    task complete_run: [ 'vm:chef_10:rebuild', :clean_run ]
  end

  namespace :chef_11 do
    desc "Set up Chef 11 test run"
    task :setup do
      puts "[chef-11] Setting up run directory"
      Run.shell_out! "mkdir -p run/chef-11"
    end

    desc "Wipe Chef 11 run data"
    task :wipe do
      puts "[chef-11] Wiping run directory"
      Run.shell_out! "rm -fr run/chef-11"
    end

    desc "Verifies Chef 11 repo matches Chef 10"
    task :verify do
      puts "[chef-11] Verifying migration integrity"
      Environment::Base.verify('run/chef-10', 'run/chef-11')
    end

    desc "Runs Chef 11 tests without cleaning"
    task run: [ 'vm:chef_11:upload', 'vm:chef_11:download', :verify ]

    desc "Runs Chef 11 tests after wiping test data"
    task clean_run: [ :wipe, :setup, :run ]

    desc "Rebuilds VMs and runs tests from scratch"
    task complete_run: [ 'vm:chef_11:rebuild', :clean_run ]
  end
end

task :report do
  Environment::Base.report
end

desc "Wipes the test data"
task wipe: [ 'run:chef_10:wipe', 'run:chef_11:wipe', 'run:chef_10:setup', 'run:chef_11:setup' ]

desc "Runs the test data without wiping"
task run: [ 'run:chef_10:run', 'run:chef_11:run', :report ]

desc "Runs the test data"
task clean_run: [ :wipe, :run ]

desc "Rebuild the VMs and runs the tests from scratch"
task complete_run: [ 'vm:chef_10:rebuild', 'vm:chef_11:rebuild', :clean_run ]
