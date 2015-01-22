require 'spec_helper'
require 'sprockets'
describe Nodeify::JavaScript do
  let(:env) { Sprockets::Environment.new }

  describe '#build_source' do
    it 'returns a hash with source, length, and digest' do
      js = Nodeify::JavaScript.new 'spec/fixtures/application.js'

      source = js.render(env, {})
      expect(source).to match /require/
    end
  end
end

