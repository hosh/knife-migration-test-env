require 'core_ext/hash'
require 'core_ext/string'
require 'core_ext/range'

require 'rlet'
require 'forgery'
require 'securerandom'
require 'multi_json'
require 'mixlib/shellout'


module Environment
  class Generator
    include ::Let

    let(:file_path) { fail "Define let(:filename)" }
    let(:base_path) { self.class.base_path }
    let(:data_path) { self.class.data_path }

    let(:data) { fail "Define let(:data)" }
    let(:json) { MultiJson.dump(data, pretty: true) }

    let(:generate!) do
      File.open(file_path, 'w') do |f|
        f.write(json)
      end
    end

    # Generation API

    def collection_name
      fail "Define self.collection_name"
    end

    def self.data_path
      File.expand_path('../data', File.dirname(__FILE__))
    end

    def self.base_path
      data_path / collection_name
    end

    def self.generate!
      generate_items!
    end

    def self.setup!
      shell_out!("mkdir -p #{base_path}")
    end

    def self.generate_items!
      (5..10).sample.times do
        self.new.generate!
      end
    end

    # Helpers
    let(:hash_from_keys) { ->(keys) { keys.inject({}) { |h,k| h.with!(k, send(k)) } } }

    let(:with_random_key_and_value) { ->(h, i) { h.with(SecureRandom.uuid, SecureRandom.base64((50..100).sample)) } }
    let(:random_hash)  { ->(m) { (1..m).to_a.inject({}, &with_random_key_and_value) } }
    let(:random_array) { ->(m) { (1..m).map { SecureRandom.uuid } } }
    let(:random_max)   { ->() { (7..10).sample } }

    def self.cwd
      data_path
    end

    def self.shell_out!(cmd, options = {})
      Mixlib::ShellOut.new(cmd, {'cwd' => cwd}.merge(options)).run_command
    end
  end
end
