require 'spec_helper'
require 'nodeify/resolver'

describe Nodeify::Resolver do
  def path_to(file)
    File.join(root, file)
  end

  let(:root) { File.expand_path('../../fixtures/CM1.js') }
  let(:resolver) { Nodeify::Resolver.new path_to('lib/CM1.js') }

  describe '#process' do
    it 'returns an array of LinkerFiles for each resolved require path' do
      result = resolver.process(%w{./impact-estimate.js ./impact-estimator.js http Reston})
      result.length.should == 4
      result.each { |r| r.should be_a(Nodeify::LinkerFile) }
    end
  end

  describe '#resolve_path' do
    it 'returns a LinkerFile for a core module' do
      resolver.should_receive :resolve_core_module
      link = resolver.resolve_path('fs')
    end
    it 'returns a LinkerFile for a relative file path' do
      resolver.should_receive :resolve_file
      resolver.resolve_path('./impact-estimate.js')
    end
    it 'returns a LinkerFile for a node module' do
      resolver.should_receive :resolve_node_module
      resolver.resolve_path('Reston')
    end
    it 'returns a LinkerFile for a relative directory path' do
      pending
    end
  end
  
  describe '#resolve_core_module' do
    it 'resolves a core module' do
      link = resolver.resolve_core_module('fs')
      link.require_path.should == 'fs'
      link.link_path.should == 'fs'
      link.real_path.should == Nodeify::Resolver.builtin_path('fs')
    end
  end

  describe '#resolve_file' do
    it 'returns a path for a file without an extension' do
      link = resolver.resolve_file('./impact-assessment')
      link.require_path.should == './impact-assessment'
      link.link_path.should be_nil
      link.real_path.should == path_to('lib/impact-assessment')
    end
    it 'returns a path for a file with a .js extension' do
      link = resolver.resolve_file('./impact-estimator')
      link.require_path.should == './impact-estimator'
      link.link_path.should be_nil
      link.real_path.should == path_to('lib/impact-estimator.js')
    end
    it 'returns a path for a file with a .coffee extension'
    it 'fails if the path is to a native .node file' do
      expect do
        resolver.resolve_file('./impact-native')
      end.to raise_error
    end
  end

  describe '#resolve_directory' do
    it 'resolves to package.json' do
      link = resolver.resolve_node_module('Reston')
      link.require_path.should == 'Reston'
      link.link_path.should be_nil
      link.real_path.should == path_to('node_modules/Reston/package.json')
    end
    it 'resolves to index' do
      link = resolver.resolve_node_module('no-package')
      link.require_path.should == 'no-package'
      link.link_path.should be_nil
      link.real_path.should == path_to('node_modules/no-package/index.js')
    end
  end

  describe '#resolve_paths' do
    it 'loads a file found in one of the module_paths'
    it 'loads a directory found in one of the module_paths'
  end

  describe '#module_paths' do
    it 'includes any node_modules directories (turtles all the way down)'
    it 'includes any paths set in NODE_PATH'
  end
end

