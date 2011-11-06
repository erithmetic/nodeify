require 'spec_helper'
require 'nodeify/linker'

describe Nodeify::Linker do
  let(:linker) { Nodeify::Linker.new './some/main' }

  it 'links a standard js lib' do
    linker = Nodeify::Linker.new File.expand_path('../../fixtures/CM1.js/browser.js', __FILE__)
    linker.link!
    absolute_path = File.expand_path('../../fixtures/CM1.js/')
    linker.files.map(&:real_path).should == [
      absolute_path + 'browser.js',
      absolute_path + 'lib/CM1.js',
      absolute_path + 'lib/impact-estimate.js',
      absolute_path + 'lib/impact-estimator.js',
      absolute_path + 'node_modules/Reston/package.json',
      absolute_path + 'node_modules/Reston/lib/Reston.js',
      absolute_path + 'node_modules/Reston/lib/FileStream.js',
      'fs',
      'path',
      absolute_path + 'node_modules/Reston/lib/Core.js',
      'events',
      absolute_path + 'node_modules/Reston/lib/MultipartWriter.js',
      'http',
      'url',
      'querystring',
      'https',
      absolute_path + 'node_modules/Reston/lib/deps/uuid.js'
    ]

    linker.files.map(&:relative_path).should == [
      './browser.js',
      './lib/CM1.js',
      './lib/impact-estimate.js',
      './lib/impact-estimator.js',
      './node_modules/Reston/package.json',
      './node_modules/Reston/lib/Reston.js',
      './node_modules/Reston/lib/FileStream.js',
      'fs',
      'path',
      './node_modules/Reston/lib/Core.js',
      'events',
      './node_modules/Reston/lib/MultipartWriter.js',
      'http',
      'url',
      'querystring',
      'https',
      './node_modules/Reston/lib/deps/uuid.js'
    ]
  end
#  it 'links a rails js app' do
#    linker = Nodeify::Linker.new File.expand_path('../../fixtures/rails_app/app/assets/javascripts/application.js', __FILE__)
#  end

  describe '#requires' do
    it 'gets a list of required module paths for a JS file' do
      File.stub! :read
      linker.stub!(:detect_requires).
        and_return %w{alpha ../lib/beta ./gamma ./alpha/delta}
      linker.requires('/path/to/file/JS').should == [
        'alpha',
        '/path/to/lib/beta',
        '/path/to/file/gamma',
        '/path/to/file/alpha/delta'
      ]
    end
    it 'gets the require path for a package.json file' do
      linker.stub!(:load_package_json).
        and_return '/path/to/npm/index.js'
      linker.requires('/path/to/npm/package.json').should == [
        '/path/to/npm/index.js'
      ]
    end
  end

  describe '#detect_requires' do
    it 'returns an empty array if no requires found' do
      requires = linker.detect_requires <<-JS
// no require();
alert('no');
      JS
      requires.should be_empty
    end
    it 'returns an array of relative requires' do
      requires = linker.detect_requires <<-JS
var alpha = require('alpha'),
    beta = require('../lib/beta');

var x = 7;
x = 5 /
  require('./gamma');
require('./alpha/delta');
      JS
      requires.should == %w{alpha ../lib/beta ./gamma ./alpha/delta}
    end
  end

  describe '#patronize' do
    it 'finds a common require path for all files'
  end
end

