require 'nodeify/linker_file'
require 'rkelly'

module Nodeify
  class Linker
    attr_accessor :files

    def initialize(main)
      self.files = [LinkerFile.from_real_path(main)]
    end

    def link!
      walk(files.first)
      patronize(files)
    end

    def walk(linker_file)
      requires(linker_file).each do |linked_file|
        walk linked_file
      end
    end

    def requires(linker_file)
      src = File.read(linker_file.real_path)
      require_paths = if(File.basename(file) == 'package.json')
        package_requires(file, src)
      else
        detect_requires(src)
      end
      resolve_requires(file, require_paths)
    end

    def package_requires(file, src)
      json = MultiJson.decode(src)
      [File.join(File.dirname(file), json['main'])]
    end

    def detect_requires(src)
      parser = RKelly::Parser.new
      ast    = parser.parse(src)

      ast.inject([]) do |requires, node|
        if node.is_a?(RKelly::Nodes::FunctionCallNode) && node.value.value == 'require'
          requires << node.arguments.value[0].value.gsub(/['"]*/,'')
        end
        requires
      end
    end

    def resolve_requires(file, require_paths)
      Resolver.process file, require_paths
    end

    def patronize(files)

    end
  end
end
