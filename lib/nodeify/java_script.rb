require 'execjs'
require 'sprockets'
require 'sandbox'

module Nodeify
  class JavaScript < Sprockets::Processor
    def render(context, options)
      source = ''
      Sandbox.play :path => 'tmp' do |path|
        js_file = File.join(path, 'nodeify.js')
        File.open(js_file, 'w') do |f|
          f.puts <<-JAVASCRIPT
var browserify = require('browserify');
var b = browserify({ entry: '#{file}' });
process.stdout.write(b.bundle());
          JAVASCRIPT
        end
        @source = `node #{js_file}` # TODO: ExecJS failed me here. Also, node can't seem to accept pipes
      end

      @source
    end
  end
end
