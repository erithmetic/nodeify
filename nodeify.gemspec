# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'nodeify/version'

Gem::Specification.new do |s|
  s.name        = 'nodeify'
  s.version     = Nodeify::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Derek Kastner']
  s.email       = ['dkastner+nodeify@gmail.com']
  s.homepage    = 'https://github.com/dkastner/nodeify'
  s.summary     = ''
  s.description = ''

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency 'execjs'
  s.add_dependency 'rails', '~> 3.1.0.rc8'
  s.add_dependency 'sandbox'
  s.add_dependency 'sprockets'
  s.add_development_dependency 'rspec'
end
