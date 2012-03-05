require 'rails/generators'

module Nodeify
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc 'Install nodeify'
      def create_app_file
        inside 'vendor/assets/javascripts' do
          copy_file 'package.json'
          run 'npm install'
        end
        git :add => 'vendor/assets/javascripts'
        git :commit => '-m "Added base nodeify npm packages"'
      end
    end
  end
end
