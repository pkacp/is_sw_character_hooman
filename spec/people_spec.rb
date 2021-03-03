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

  # TODO Move to shared examples
  describe '#includes' do
    before :all do
      @hash_params = JSON.parse(File.read('spec/fixtures/link/people.json'))
      subject { described_class.new(@hash_params) }
    end

    it 'should take unlimited number of parameters' do
      expect(subject).to respond_to(:includes).with_unlimited_arguments
    end

    it 'should raise MissingKeyError if no such key is present' do
      expect(subject.includes('fake_key')).to raise_error(MissingKeyError)
    end

    context 'when provided valid key' do
      it 'should raise WrongKeyError if value of key is not a collection' do
        expect(subject.includes('name')).to raise_error(WrongKeyError)
      end

      context 'when no action is needed' do
        it 'should return already_done if collection is empty' do
          expect(subject.includes('species')).to eq 'already_done'
        end

        it 'should return already_done if collection is made of Resource objects' do
          species_resource = SWApi::Species.new(Hash.new)
          params_with_species_resource = @hash_params.merge(species: [species_resource])
          test_subject = described_class.new(params_with_species_resource)

          # when
          res = test_subject.includes(:species)

          # then
          expect(res).to eq 'already_done'
        end
      end

      it 'should call SWApi::BaseResource.get_from_link for each link in collection' do
        base_resource = class_double("SWApi::BaseResource", get_from_link: nil)
        species_links_array = %w[http://swapi.dev/api/species/1/ http://swapi.dev/api/species/2/]
        params_with_species = @hash_params.merge(species: species_links_array)
        test_subject = described_class.new(params_with_species)

        # when
        test_subject.includes(:species)

        # then
        expect(base_resource).to receive(:get_from_link).twice
      end

      it 'should insert at requested key returned values' do
        species_resource = 'fake_resource'
        class_double("SWApi::BaseResource", get_from_link: species_resource)
        species_links_array = %w[http://swapi.dev/api/species/1/ http://swapi.dev/api/species/2/]
        params_with_species = @hash_params.merge(species: species_links_array)
        test_subject = described_class.new(params_with_species)

        # when
        test_subject.includes(:species)

        # then
        expect(test_subject.species).to be_kind_of Enumerable
        expect(test_subject.species).to all(be_a(String).and include(species_resource))
      end
    end
  end
end
