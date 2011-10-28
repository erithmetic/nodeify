require 'spec_helper'
require 'nodeify/compiler'

describe Nodeify::Compiler do
  let(:application_js) { File.expand_path('../../fixtures/standard/application.js', __FILE__) }
  let(:compiler) { Nodeify::Compiler.new :main => application_js }
  let(:stringio) { StringIO.new }

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
      Sandbox.play do |path|
        compiler.outfile = File.join(path, 'test.js')
        stream = compiler.compile
        File.read(compiler.outfile).should =~ /process/
      end
    end
  end

  describe '#compile_prepends' do
    it 'compiles any specified prepends' do
      compiler.compile_prepends stringio
      stringio.rewind
      stringio.read.should =~ /require/
    end
    it 'provides an extensions variable to the ERB' do
      compiler.compile_prepends stringio
      stringio.rewind
      stringio.read.should =~ /require\.extensions = \["\.js"\];/
    end
  end

  describe '#compile_files' do
    it 'compiles all the files' do
      compiler.files = {
        File.expand_path('../../fixtures/application.js', __FILE__) =>
          './application.js'
      }
      compiler.compile_files stringio
      stringio.rewind
      src = stringio.read
      src.should =~ /require/
      src.should =~ /foo/
      src.should =~ /application\.js/
    end
  end
end

