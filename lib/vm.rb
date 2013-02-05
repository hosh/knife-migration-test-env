require 'core_ext/string'
require 'core_ext/hash'
require 'mixlib/shellout'
require 'active_support/core_ext/object/blank'
require 'chef_fs/knife'
require 'chef_fs/command_line'

module Environment
  class VM
    def self.root_path
      File.expand_path('..', File.dirname(__FILE__))
    end

    def self.base_path
      fail "Define self.base_path"
    end

    def self.shell_out(cmd, options = {})
      Mixlib::ShellOut.new(cmd, {'cwd' => base_path, live_stream: STDOUT}.merge(options)).run_command
    end

    def self.shell_out!(cmd, options = {})
      shell_out(cmd, options).tap do |o|
        puts "ERROR: #{o.stderr}" unless o.stderr.blank?
        o.error!
      end
    end

    def self.bundle_exec!(cmd, options = {})
      shell_out! "bundle exec #{cmd}", options
    end

    def self.vagrant!(cmd, options = {})
      bundle_exec! "vagrant #{cmd}", options
    end
  end

  class Base < VM
    def self.base_path
      root_path
    end

    # Patches into knife-essentials diff algorithim
    def self.diff(a, b)
      shell_out "diff -r #{a} #{b}", returns: [0,1], live_stream: nil
    end

    def self.verify(a, b)
      _diff = diff(a,b)
      case _diff.exitstatus
      when 1
        puts "[chef-10] ERROR: Data integrity failed"
        puts _diff.stdout
        self.log << _diff.stdout
      when 0
        puts "[chef-10] Data integrity nominal."
      else
        puts "Unexpected status code: #{_diff.status}"
      end
    end

    def self.log
      @_report ||= []
    end

    def self.report
      if self.log.empty?
        puts "\nTest results: Pass."
      else
        puts "\nERRORS: Data integrity checks failed:"
        puts self.log
      end
    end
  end

  class Chef10 < VM
    def self.base_path
      root_path / "chef-10"
    end
  end

  class Chef11 < VM
    def self.base_path
      root_path / "chef-11"
    end
  end
end

Run = Environment::Base

def Chef(version)
  case version
  when 10
    Environment::Chef10
  when 11
    Environment::Chef11
  else
    fail "Invalid Chef version"
  end
end
