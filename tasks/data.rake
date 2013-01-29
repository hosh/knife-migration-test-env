require 'generators/data_bag'

namespace :data do
  namespace :generate do

    desc "Generates data_bag"
    task :data_bag do

      Environment::Generators::DataBag.generate!
    end
  end
end
