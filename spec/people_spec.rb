require_relative '../lib/sw_api/resources/people.rb'
require 'json'

RSpec.describe SWApi::People do
  it_behaves_like "a star wars api resource"

  before :all do
    @people_resource = 'people'
  end

  describe '.resource' do
    it 'should equal people' do
      expect(described_class.resource).to eq @people_resource
    end
  end

  context 'getters' do
    before :all do
      @hash_params = JSON.parse(File.read('spec/fixtures/link/people.json'))
    end

    describe '#name' do
      it 'should be a string' do
        test_subject = described_class.new(@hash_params)
        expect(test_subject.name).to be_an_instance_of String
      end

      it 'should be name from passed params' do
        test_subject = described_class.new(@hash_params)
        expect(test_subject.name).to eql 'Luke Skywalker'
      end
    end

    describe '#species' do
      it 'should return a collection' do
        test_subject = described_class.new(@hash_params)
        expect(test_subject.species).to be_kind_of Enumerable
      end

      context 'when species links in params empty' do
        it 'should return empty collection' do
          test_subject = described_class.new(@hash_params)
          expect(test_subject.species).to be_empty
        end
      end

      context 'when species links in params present' do
        it 'should return collection of links' do
          species_links_array = %w[http://swapi.dev/api/species/1/ http://swapi.dev/api/species/2/]
          params_with_species = @hash_params.merge(species: species_links_array)
          test_subject = described_class.new(params_with_species)
          expect(test_subject.species).to contain_exactly(species_links_array)
        end
      end
    end
  end

end