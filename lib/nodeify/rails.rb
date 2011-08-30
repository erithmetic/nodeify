require 'nodeify/java_script'

require 'sprockets'
require 'execjs'
require 'rails'

module Nodeify
  class Rails < Rails::Railtie
    initializer "nodeify.sprockets.environment" do |app|
      ExecJS.runtime = ExecJS::Runtimes::Node
      app.assets.unregister_preprocessor 'application/javascript', Sprockets::DirectiveProcessor
      app.assets.register_bundle_processor 'application/javascript', Nodeify::JavaScript
    end
  end
end
