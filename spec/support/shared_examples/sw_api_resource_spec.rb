shared_examples 'a star wars api resource' do
  before :all do
    @sw_api_url = 'https://swapi.dev/api/'
    @search_specifier = '?search='
  end

  describe '.new' do
    it 'should take one Hash argument' do
      expect(described_class).to respond_to(:new).with(1).argument
      expect(described_class.new(Hash.new)).not_to raise_error ArgumentError
    end
  end

  describe '.base_url' do
    it 'should be set to sw api url' do
      expect(described_class.base_url).to eq(@sw_api_url)
    end
  end

  describe '.search_specifier' do
    it 'should be set to sw api url' do
      expect(described_class.search_specifier).to eq(@search_specifier)
    end
  end

  describe '.resource' do
    it 'should return string' do
      expect(described_class.resource).to be_an_instance_of String
    end

    it 'should return non empty string' do
      expect(described_class.resource).not_to be_empty
    end
  end

  describe '.url' do
    it 'should start with sw api url' do
      expect(described_class.url).to start_with(@sw_api_url)
    end

    it 'should end with defined resource' do
      expect(described_class.url).to end_with(described_class.resource)
    end

    it 'should be valid url' do
      expect(described_class.url).to be_a_url
    end
  end

  describe '.search' do
    before :all do
      @sample_text = 'sample'
      @sample_described_class_url = "#{@sw_api_url}#{described_class.resource}"
      @expected_request_path = "#{@sample_described_class_url}/#{@search_specifier}#{@sample_text}"
      allow(HttpConnector).to receive(:get).and_return(Hash.new)
    end

    subject { described_class.search(@sample_text) }

    it 'should take one argument' do
      expect(described_class).to respond_to(:search).with(1).argument
    end

    it 'should call HttpConnector once with correct url' do
      expect(HttpConnector).to receive(:get).with(@expected_request_path)
    end

    context 'when correct response from server' do
      it 'should return a collection' do
        search_response_none = JSON.parse(File.read('spec/fixtures/search/none_results.json'))
        allow(HttpConnector).to receive(:get).and_return(search_response_none)
        expect(described_class.search(@sample_text)).to be_kind_of Enumerable
      end

      context 'when server responds with no results' do
        it 'should return an empty collection' do
          search_response_none = JSON.parse(File.read('spec/fixtures/search/none_results.json'))
          allow(HttpConnector).to receive(:get).and_return(search_response_none)
          expect(described_class.search(@sample_text)).to be_empty
        end
      end

      context 'when server responds with multiple results' do
        it "should return collection of #{described_class} objects" do
          search_response_multiple = JSON.parse(File.read('spec/fixtures/search/multiple_results.json'))
          allow(HttpConnector).to receive(:get).and_return(search_response_multiple)
          expect(described_class.search(@sample_text)).to all(be_an_instance_of(described_class))
        end
      end
    end
  end
end

