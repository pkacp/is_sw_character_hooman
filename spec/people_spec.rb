require_relative '../lib/sw_api/people.rb'

RSpec.describe SWApi::People do
  it_behaves_like "a star wars api class"

  before :all do
    @people_resource = 'people'
  end

  describe '.resource' do
    it 'should equal people' do
      expect(described_class.resource).to eq @people_resource
    end
  end


end