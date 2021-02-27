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

end