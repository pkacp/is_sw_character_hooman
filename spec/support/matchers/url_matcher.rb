RSpec::Matchers.define :be_a_url do |expected|
  match do |actual|
    actual =~ URI::regexp
  end
end