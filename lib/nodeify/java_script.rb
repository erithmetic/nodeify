require 'tilt'
require 'sandbox'

module Nodeify
  class JavaScript < Tilt::Template
    attr_accessor :body

    def initialize(*arg)
      super
    end

    def prepare
    end

    def evaluate(context, options)
      output = ''
      Sandbox.play do |path|
        file_path = File.join(path, File.basename(file))
        File.open(file_path, 'w') { |f| f.puts data }
        output = `node -e "var browserify = require('browserify'), _ = process.stdout.write(browserify({ entry: '#{file_path}', require: { http: 'dkastner-http-browserify' } }).bundle());"`
      end
      output
    end
  end
end
