require_relative '../lib/sw_api/resources/base_resource.rb'

RSpec.describe SWApi::BaseResource do
  before :all do
    @sw_api_url = 'https://swapi.dev/api/'
  end

  describe '.base_url' do
    it 'should be set to sw api url' do
      expect(described_class.base_url).to eq(@sw_api_url)
    end
  end

  describe '.resource' do
    it 'should raise NotImplementedError' do
      expect { described_class.resource }.to raise_error NotImplementedError
    end
  end

  describe '.search' do
    it 'should raise NotImplementedError' do
      expect { described_class.resource }.to raise_error NotImplementedError
    end
  end

  describe '.get_from_link' do

    before :all do
      @link_resource = "#{@sw_api_url}people/1/"
    end

    it 'should take one argument' do
      expect(described_class).to respond_to(:get_from_link).with(1).argument
    end

    it_behaves_like "a web request", @link_resource

    it 'should make request to given link' do
      # given
      stubbed_link = stub_request(:get, @link_resource)
      # when
      described_class.get_from_link(@link_resource)
      # then
      expect(stubbed_link).to have_been_made.once
    end

    context 'when server responds with valid response' do
      context 'People resource' do # TODO Refactor to DRY
        it 'should attempt to create instance of resource' do
          # given
          people_resource_class = class_double('People', resource: 'people')
          # when
          described_class.get_from_link(@link_resource)
          # then
          expect(people_resource_class).to receive(:new).once
        end

        it 'should return resource instance' do
          # given
          people_sample_json = File.new('spec/fixtures/link/people.json')
          stub_request(:get, @link_resource).to_return(body: people_sample_json, status: 200)
          # when
          result = described_class.get_from_link(@link_resource)
          # then
          expect(result).to be_an_instance_of SWApi::People
        end
      end

      context 'Specie resource' do
        @link_resource = "#{@sw_api_url}species/1/"
        it 'should attempt to create instance of resource' do
          # given
          species_resource_class = class_double('Species', resource: 'species')
          # when
          described_class.get_from_link(@link_resource)
          # then
          expect(species_resource_class).to receive(:new).once
        end

        it 'should return resource instance' do
          # given
          species_sample_json = File.new('spec/fixtures/link/species.json')
          stub_request(:get, @link_resource).to_return(body: species_sample_json, status: 200)
          # when
          result = described_class.get_from_link(@link_resource)
          # then
          expect(result).to be_an_instance_of SWApi::Species
        end
      end
    end

  end


end