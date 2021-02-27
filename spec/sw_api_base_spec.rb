require_relative '../lib/sw_api/sw_api_base.rb'

RSpec.describe SWApi::SWApiBase do
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

end