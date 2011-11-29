module Nodeify
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc 'Install nodeify'


      def create_app_file
        template 'package.json', 'package.json'
      end
    end
  end
end
