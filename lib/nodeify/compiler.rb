require 'multi_json'

module Nodeify
  class Compiler
    attr_accessor :main, :outfile
      
    attr_accessor :json_engine, :prepends, :files, :aliases, :extensions

    def initialize(options = {})
      options.each do |name, value|
        send "#{name}=", value
      end

      # alias[to] = from
      self.files ||= {}
      self.aliases ||= {}
      self.json_engine ||= :json_gem

      self.extensions ||= ['.js'];

      self.prepends = [
        File.expand_path('../../../assets/wrappers/prelude.js.erb', __FILE__),
        File.expand_path('../../../assets/wrappers/process.js.erb', __FILE__)
      ]

      @template_cache = {}
    end

    def output_stream
      stream = outfile ? File.open(outfile, 'w') : StringIO.new
      yield stream
      stream.close
      stream
    end

    def compile
      output_stream do |stream|
        compile_prepends stream
        compile_files stream
        compile_aliases stream
        compile_main stream
      end
    end

    def compile_prepends(stream)
      prepends.each do |prepend|
        stream.write wrap(prepend, binding)
        stream.write "\n"
      end
    end

    def compile_files(stream)
      files.each do |real_path, relative_path|
        File.open(real_path, 'r') do |f|
          filename = relative_path
          body = f.gets.sub(/^#![^\n]*\n/, '')
          src = wrap(File.expand_path('../../../assets/wrappers/body.js.erb', __FILE__),
                     binding)
          stream.write src
        end
        stream.write "\n"
      end
    end

    def compile_aliases(stream)
      aliases.each do |to, from|
        if to !~ /^(\.\.?)?\//
          to = '/node_modules/' + to
        end
        body = f.gets.sub(/^#![^\n]*\n/, '')
        src = wrap(File.expand_path('../../../assets/wrappers/alias.js.erb', __FILE__),
                   binding)
        stream.write src
        stream.write "\n"
      end
    end

    def compile_main(stream)
      File.open(main) do |f|
        dirname = ''
        filename = main
        body = f.gets

        src = wrap(File.expand_path('../../../assets/wrappers/entry.js.erb', __FILE__),
                   binding)

        stream.write src
      end
      stream.write "\n"
    end

    def wrap(wrapper, binding)
      @template_cache[wrapper] ||= ERB.new(File.read(wrapper))
      template = @template_cache[wrapper]
      template.result(binding)
    end
  end
end
