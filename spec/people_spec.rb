require_relative '../lib/sw_api/people.rb'

RSpec.describe SWApi::People do
  it_behaves_like "a star wars api class"

  before :all do
    @people_type = 'people'
  end

  describe '.type' do
    it 'should equal people' do
      expect(described_class.type).to eq @people_type
    end
  end


end