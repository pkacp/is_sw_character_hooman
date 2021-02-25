require_relative '../lib/sw_api/people.rb'

RSpec.describe SWApi::People do
  it_behaves_like "a star wars api class"

  before :all do
    @people_type = 'people'
  end


end