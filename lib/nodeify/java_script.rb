require 'sprockets'

module Nodeify
  class JavaScript < Sprockets::Processor
    def render(context, options)
      @source = `node -e "var browserify = require('browserify'), _ = process.stdout.write(browserify({ entry: '#{file}', require: { http: 'dkastner-http-browserify' } }).bundle());"`
      @source
    end
  end
end
