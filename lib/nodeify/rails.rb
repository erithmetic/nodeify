require 'generators/nodeify/install_generator'
require 'nodeify/java_script'

require 'sprockets'
require 'rails'

module Nodeify
  class Rails < Rails::Railtie
    initializer "nodeify.sprockets.environment" do |app|
      app.assets.unregister_preprocessor 'application/javascript', Sprockets::DirectiveProcessor
      app.assets.register_bundle_processor 'application/javascript', Nodeify::JavaScript
    end
  end
end
