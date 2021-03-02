Rspec.describe Character do
  describe '.new' do
    it 'should take unlimited named parameters' do
      expect(described_class).to respond_to(:new).with_unlimited_arguments
    end

    it 'should raise ArgumentError if no name argument provided' do
      expect(described_class.new(race: [])).to raise_error(ArgumentError)
    end

    it 'should raise ArgumentError if no race argument provided' do
      expect(described_class.new(name: 'fake_name')).to raise_error(ArgumentError)
    end

    it 'sould raise TypeError if race is not a collection' do
      expect(described_class.new(name: 'fake_name', race: nil)).to raise_error(TypeError)
    end
  end

  describe '#human?' do
    it 'should return true if character race is a human' do
      mock_race = instance_double('Race', name: 'human')
      test_subject = described_class.new(name: 'fake_name', race: [mock_race])
      expect(test_subject.human?).to eq true
    end

    it 'should return true if any of character race is a human' do
      mock_human_race = instance_double('Race', name: 'human')
      mock_nonhuman_race = instance_double('Race', name: 'not a human')
      test_subject = described_class.new(name: 'fake_name', race: [mock_nonhuman_race, mock_human_race])
      expect(test_subject.human?).to eq true
    end

    it 'should return false if none of character race is a human' do
      mock_race = instance_double('Race', name: 'not a human')
      test_subject = described_class.new(name: 'fake_name', race: [mock_race])
      expect(test_subject.human?).to eq false
    end
  end

  describe '#name' do
    it 'should return name of character' do
      fake_name = 'fake_name'
      test_subject = described_class.new(name: fake_name, race: [])
      expect(test_subject.name).to eq fake_name
    end
  end
end