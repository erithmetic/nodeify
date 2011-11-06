require 'nodeify/linker_file'

module Nodeify
  class Resolver
    class ModuleNotFoundError < StandardError; end

    attr_accessor :file

    def self.builtin_path(file)
      File.expand_path("../../../assets/builtins/#{file}", __FILE__)
    end

    def initialize(file)
      self.file = file
    end

    def core_module?(name)
      %w{assert buffer child_process crypto dgram dns events
         fs http https net os path querystring repl stream
         sys tls tty url util vm}.include?(name)
    end

    def process(paths)
      paths.map do |path|
        resolve_path(path)
      end
    end

    def resolve_path(path)
      if core_module?(path)
        resolve_core_module(path)
      elsif(path =~ /^\./)
        resolve_file(path)
      else
        resolve_node_module(path)
      end
    end

    def resolve_core_module(path)
      link = LinkerFile.new path, Resolver.builtin_path(path)
      link.link_path = path
      link
    end

    def resolve_file(path)
      fail ModuleNotFoundError.new("Cannot find target for `require('#{path}')`")
    end

    def resolve_node_module(path)
    end
  end
end
