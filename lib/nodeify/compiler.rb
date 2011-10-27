require 'multi_json'

module Nodeify
  class Compiler
    attr_accessor :main, :json_engine, :prepends, :extensions

    attr_accessor :compiled_prepends

    def initialize(options = {})
      options.each do |name, value|
        send "#{name}=", value
      end

      self.json_engine ||= :json_gem

      self.extensions = ['.js'];

      self.prepends = [
        File.expand_path('../../../assets/wrappers/prelude.js.erb', __FILE__),
        File.expand_path('../../../assets/wrappers/process.js.erb', __FILE__)
      ]
    end

    def compile
      compile_prepends
#      
#      var src = []
#        .concat(this.prepends)
#        .concat(Object.keys(self.files).map(function (name) {
#            return self.files[name].body;
#        }))
#        .concat(Object.keys(self.aliases).map(function (to) {
#            var from = self.aliases[to];
#            if (!to.match(/^(\.\.?)?\//)) {
#                to = '/node_modules/' + to;
#            }
#            
#            return wrappers.alias
#                .replace(/\$from/, function () {
#                    return JSON.stringify(from);
#                })
#                .replace(/\$to/, function () {
#                    return JSON.stringify(to);
#                })
#            ;
#        }))
#        .join('\n')
#    ;
      (compiled_prepends).join("\n")
    end

    def compile_prepends
      extensions = MultiJson.encode(self.extensions)
      self.compiled_prepends = prepends.map do |prepend|
        erb = ERB.new File.read(prepend)
        erb.result binding
      end
    end
  end
end
