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
      @hash_params = Json.parse(File.read('spec/fixtures/link/people.json'))
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
        before :each do
          @hash_params_with_one_species = @hash_params_with_two_species = @hash_params
          species_1_path = 'http://swapi.dev/api/species/1/'
          species_2_path = 'http://swapi.dev/api/species/2/'
          @hash_params_with_one_species['species'] = [species_1_path]
          @hash_params_with_two_species['species'] = [species_1_path, species_2_path]
          @request_species_1 = stub_request(:get, species_1_path)
          @request_species_2 = stub_request(:get, species_2_path)
        end

        it 'should make request to species link' do
          test_subject = described_class.new(@hash_params_with_one_species)
          test_subject.species
          expect(@request_species_1).to have_been_made.once
        end

        it 'shoule make request to each species link' do
          test_subject = described_class.new(@hash_params_with_two_species)
          test_subject.species
          expect(@request_species_1).to have_been_made.once
          expect(@request_species_2).to have_been_made.once
        end

        it 'shoule return a collection of SWApi::Species' do
          test_subject = described_class.new(@hash_params_with_two_species)
          result = test_subject.species
          expect(result).to all(be_an(SWApi::Species))
        end

      end
    end
  end

end