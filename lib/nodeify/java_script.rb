require 'sprockets'
require 'fileutils'

module Nodeify
  class JavaScript < Sprockets::DirectiveProcessor
    def evaluate(context, options, &blk)
      super

      file_path = File.absolute_path(file + '.tmp')
      File.open(file_path, 'w') { |f| f.puts @result }
      @result = `node -e "var browserify = require('browserify'); var b = browserify(); b.add('#{file_path}'); b.bundle().pipe(process.stdout);"`
      FileUtils.rm_f file_path

      @result
    end
  end
end
