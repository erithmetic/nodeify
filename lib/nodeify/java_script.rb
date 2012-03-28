require 'sprockets'
require 'fileutils'

module Nodeify
  class JavaScript < Sprockets::DirectiveProcessor
    def evaluate(context, options, &blk)
      super

      file_path = file + '.tmp'
      File.open(file_path, 'w') { |f| f.puts @result }
      @result = `node -e "var browserify = require('browserify'), _ = process.stdout.write(browserify({ entry: '#{file_path}', require: { http: 'http-browserify' } }).bundle());"`
      FileUtils.rm_f file_path

      @result
    end
  end
end
