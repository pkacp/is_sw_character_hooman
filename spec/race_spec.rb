require_relative '../lib/race.rb'

RSpec.describe Race do
  describe '.new' do
    it 'should take unlimited named parameters' do
      expect(described_class).to respond_to(:new).with_any_keywords
    end

    it 'should raise ArgumentError if no name argument provided' do
      expect{described_class.new(other_param: 'other_param')}.to raise_error(ArgumentError)
    end
  end

  describe '#name' do
    it 'should return name of race' do
      fake_name = 'fake_name'
      test_subject = described_class.new(name: fake_name)
      expect(test_subject.name).to eq fake_name
    end
  end
end