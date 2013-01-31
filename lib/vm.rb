require 'core_ext/string'
require 'mixlib/shellout'
require 'active_support/core_ext/object/blank'

module Environment
  class VM
    def self.root_path
      File.expand_path('..', File.dirname(__FILE__))
    end

    def self.base_path
      fail "Define self.base_path"
    end

    def self.shell_out!(cmd, options = {})
      Mixlib::ShellOut.new(cmd, {'cwd' => base_path, live_stream: STDOUT}.merge(options)).run_command.tap do |o|
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
