require 'execjs'
require 'sprockets'
require 'sandbox'

module Nodeify
  class JavaScript < Sprockets::Processor
    BIN = File.expand_path('../../../bin/nodeify', __FILE__)

    def render(context, options)
      @source = `node #{BIN} #{file}`
    end
  end
end
