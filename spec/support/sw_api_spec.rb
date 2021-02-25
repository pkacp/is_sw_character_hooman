shared_examples 'a star wars api class' do
  before :all do
    @base_url = 'https://swapi.dev/api/' # TODO Should it be here/in api base/neither
    @fake_type = 'fake_type'
    @sample_described_class_url = @base_url + @fake_type
  end

  describe '.base_url' do
    it 'should be set to sw api url' do
      expect(described_class.base_url).to eq(@base_url)
    end
  end

  describe '.type' do
    it 'should return string' do
      expect(described_class.type).to be_an_instance_of String
    end
  end

  describe '.url' do
    it 'should start with sw api url' do
      expect(described_class.url).to start_with(@base_url)
    end

    it 'should end with defined type' do
      expect(described_class.url).to end_with(@fake_type)
    end
  end

  describe '.search' do
    before :all do
      @sample_searched_text = 'sample'
      @expected_request_path = "#{@sample_described_class_url}/?search=#{@sample_searched_text}"
    end
    subject { described_class.search(@sample_searched_text) }
    it_behaves_like "a web request", @expected_request_path

    it 'should take one argument' do
      expect(described_class).to respond_to(:search).with(1).argument
    end

    # First approach .to_s
    # Second approach String()
    # Third approach is an instance of String
    xit 'argument should behave like string' do
      expect { described_class.search(:r2) }.not_to raise_error ArgumentError
      expect { described_class.search('r2') }.not_to raise_error ArgumentError
      expect { described_class.search(nil) }.not_to raise_error ArgumentError
      expect { described_class.search(96) }.not_to raise_error ArgumentError
    end

    it 'should create correct query with searched text' do
      # given
      search_request = stub_request(:get, @expected_request_path)

      # when
      described_class.search(searched_text)

      #then
      expect(search_request).to have_been_made.once
    end
  end
end

shared_examples 'a web request' do |request_url|
  describe 'in offline situation' do
    it 'should rise NoInternetError' do
      stub_request(:get, request_url).to_raise(StandardError)
      expect(subject).to raise_error ConnectionError
    end
  end

  describe 'when server not found' do
    it 'should return ServerNotFound' do
      stub_request(:get, request_url).to_timeout
      expect(subject).to raise_error ServerNotFound
    end
  end

  describe 'when api server error' do
    it 'should return InternalServerError' do
      stub_request(:get, request_url).to_return(status: [500, "Internal Server Error"])
      expect(subject).to raise_error InternalServerError
    end
  end
# 200
end

