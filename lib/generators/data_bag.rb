require 'generator'

module Environment
  module Generators
    class DataBag < Generator
      let(:file_path) { base_path / "#{item_id}.json" }
      let(:keys)      { fail "Define let(:keys) as an array of keys for databag" }

      let(:data) { { id: item_id }.merge(hash_from_keys.(keys)) }

      def self.collection_name
        'databags'
      end

      def self.base_path
        super / databag_name
      end

      def self.databag_name
        fail "Define self.databag_name"
      end

      def self.generate!
        [
          Environment::Generators::User,
          Environment::Generators::Random
        ].each do |generator|
          generator.setup!
          generator.generate_items!
        end
      end
    end

    class User < DataBag
      let(:item_id)      { username }
      let(:keys)         { %w(username groups uid shell email comment ssh_pub_key) }

      let(:username)     { Forgery(:internet).user_name }
      let(:groups)       { 'sysadmin' }
      let(:uid)          { (5000..9999).sample }
      let(:shell)        { '/bin/bash' }
      let(:email)        { Forgery(:internet).email_address }
      let(:comment)      { Forgery(:name).full_name }
      let(:ssh_pub_key)  { "ssh-rsa #{public_key} #{username}"  }

      let(:private_key)  { OpenSSL::PKey::RSA.new(2048) }
      let(:public_key)   { private_key.public_key.to_s }

      def self.databag_name
        'users'
      end
    end

    class Random < DataBag
      let(:item_id)      { SecureRandom.uuid }
      let(:data)         { { id: item_id }.merge(random_hash.(random_max.())) }

      def self.databag_name
        'random'
      end
    end
  end
end
