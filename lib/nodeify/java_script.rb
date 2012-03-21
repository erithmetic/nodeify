require 'tilt'
require 'sandbox'
require 'sprockets'

module Nodeify
  class JavaScript < Sprockets::DirectiveProcessor
    def evaluate(context, options, &blk)
      super

      Sandbox.play do |path|
        file_path = File.join(path, File.basename(file))
        File.open(file_path, 'w') { |f| f.puts @result }
        @result = `node -e "var browserify = require('browserify'), _ = process.stdout.write(browserify({ entry: '#{file_path}', require: { http: 'dkastner-http-browserify' } }).bundle());"`
      end

      @result
    end
  end
end
