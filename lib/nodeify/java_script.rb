require 'execjs'
require 'sprockets'
require 'sandbox'

module Nodeify
  class JavaScript < Sprockets::Processor
    def render(context, options)
      source = ''
      js_file = File.join('tmp', 'nodeify.js')
      File.open(js_file, 'w') do |f|
        f.puts <<-JAVASCRIPT
var browserify = require('browserify');
var b = browserify({ entry: '#{file}' });
process.stdout.write(b.bundle());
        JAVASCRIPT
      end
      puts "running node #{js_file}"
      puts "source: #{File.read(js_file)}"
      @source = `node #{js_file}`
      FileUtils.rm_f js_file

      @source
    end
  end
end
