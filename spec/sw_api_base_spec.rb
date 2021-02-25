require_relative '../lib/sw_api/sw_api_base.rb'

RSpec.describe SWApi::SWApiBase do
  before :all do
    @base_url = 'https://swapi.dev/api/'
  end

  describe '.base_url' do
    it 'should be set to sw api url' do
      expect(described_class.base_url).to eq(@base_url)
    end
  end

  describe '.type' do
    it 'should raise NotImplementedError' do
      expect { described_class.type }.to raise_error NotImplementedError
    end
  end

end