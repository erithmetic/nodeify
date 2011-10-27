require 'spec_helper'
require 'nodeify/compiler'

describe Nodeify::Compiler do
  let(:application_js) { File.expand_path('../../fixtures/standard/application.js', __FILE__) }
  let(:compiler) { Nodeify::Compiler.new :main => application_js }

  it 'has default prepends' do
    compiler.prepends.should include(
      File.expand_path('../../../assets/wrappers/prelude.js.erb', __FILE__))
    compiler.prepends.should include(
      File.expand_path('../../../assets/wrappers/process.js.erb', __FILE__))
  end

  it 'has a default entry point' do
    File.basename(compiler.main).should =~ /application.js/
  end

  describe 'usage' do
    it 'compiles an application' do
      compiler.compile.should =~ /process/
    end
  end

  describe '#compile_prepends' do
    it 'compiles any specified prepends' do
      compiler.compile_prepends
      compiler.compiled_prepends.first.should =~ /require/
    end
    it 'provides an extensions variable to the ERB' do
      compiler.compile_prepends
      compiler.compiled_prepends.first.should =~ /require\.extensions = \["\.js"\];/
    end
  end
end

