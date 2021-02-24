shared_examples 'a star wars api class' do
  before :all do
    @base_url = 'https://swapi.dev/api/'
  end

  describe '.base_url' do
    it 'should be set to sw api url' do
      expect(described_class.base_url).to eql?(@base_url)
    end
  end

  describe '.url' do
    it 'should start with sw api url' do
      expect(described_class.url).to start_with(@base_url)
    end
  end

  describe '.search' do
    subject { described_class.search('sample') }
    it_behaves_like "a web request"

    it 'should take one argument' do
      expect(described_class).to respond_to(:search).with(1).argument
    end

    # First approach .to_s
    # Second approach String()
    # Third approach is an instance of String
    it 'argument should behave like string' do
      expect { described_class.search(:r2) }.not_to raise_error ArgumentError
      expect { described_class.search('r2') }.not_to raise_error ArgumentError
      expect { described_class.search(nil) }.not_to raise_error ArgumentError
    end

    it 'should create correct query with searched text' do
      # given
      searched_text = 'yoda'
      fake_described_type = 'fake_described_type'
      search_request = stub_request(:get, "#{@base_url}#{fake_described_type}/?search=#{searched_text}")

      # when
      described_class.search(searched_text)

      #then
      expect(search_request).to have_been_made.once
    end
  end
end

shared_examples 'a web request' do
  # offline
  # 500
  # 400
  # 200
end

