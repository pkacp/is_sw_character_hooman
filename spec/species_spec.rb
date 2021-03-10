require_relative '../lib/sw_api/resources/species.rb'
require 'json'

RSpec.describe SWApi::Species do
  it_behaves_like "a star wars api resource"

  before :all do
    @species_resource = 'species'
  end

  describe '.resource' do
    it 'should equal species' do
      expect(described_class.resource).to eq @species_resource
    end
  end

  context 'getters' do
    before :all do
      @hash_params = JSON.parse(File.read('spec/fixtures/link/species.json'))
    end

    describe '#name' do
      it 'should be a string' do
        test_subject = described_class.new(@hash_params)
        expect(test_subject.name).to be_an_instance_of String
      end

      it 'should be name from passed params' do
        test_subject = described_class.new(@hash_params)
        expect(test_subject.name).to eql 'Human'
      end
    end

  end
end
