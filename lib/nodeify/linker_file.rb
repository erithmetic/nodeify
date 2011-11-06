module Nodeify
  class LinkerFile
    def self.process()
      new path
    end

    attr_accessor :require_path, :link_path, :real_path

    def initialize(require_path, real_path)
      self.require_path = require_path
      self.real_path = real_path
    end
  end
end
