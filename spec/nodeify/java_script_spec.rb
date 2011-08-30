require 'spec_helper'
require 'sprockets'

describe Nodeify::JavaScript do
  let(:env) { Sprockets::Environment.new }

  describe '#build_source' do
    it 'returns a hash with source, length, and digest' do
      js = Nodeify::JavaScript.new 'spec/fixtures/application.js'
      source = js.render(env, {})
      source.should =~ /require/
    end
  end
end

