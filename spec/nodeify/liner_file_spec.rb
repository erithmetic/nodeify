require 'spec_helper'
require 'nodeify/linker_file'

describe Nodeify::LinkerFile do
  describe '.process' do
    let(:cm1) { File.expand_path('../../fixtures/CM1.js/lib/CM1.js', __FILE__) }

    it 'handles relative files'
    it 'handles node modules' do
      file = Nodeify::LinkerFile.process('Reston', cm1)
      file.real_path.should == File.expand_path('../../fixtures/CM1.js/node_modules/Reston/lib/Reston.js', __FILE__)
      file.relative_path.should == '../node_modules/Reston/lib/Reston.js'
    end
    it 'handles core modules' do
      file = Nodeify::LinkerFile.process('http', '/path/to/some/file.js')
      file.real_path.should == File.expand_path('../../../assets/builtins/http.js', __FILE__)
      file.relative_path.should == 'http'
    end
  end
end

