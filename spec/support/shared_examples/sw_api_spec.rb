shared_examples 'a star wars api resource' do
  before :all do
    @sw_api_url = 'https://swapi.dev/api/' # TODO Should it be here/in api base/neither?
    @search_specifier = '?search='
    # @fake_resource = 'fake_resource'
  end

  describe '.new' do
    it 'should accept Hash argument' do
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
      @sample_searched_text = 'sample'
      @sample_described_class_url = "#{@sw_api_url}#{described_class.resource}"
      @expected_request_path = "#{@sample_described_class_url}/#{@search_specifier}#{@sample_searched_text}"
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

    context 'when correct response from server' do
      it 'should make correct query with searched text' do
        # given
        search_request = stub_request(:get, @expected_request_path)

        # when
        described_class.search(@sample_searched_text)

        #then
        expect(search_request).to have_been_made.once
      end

      it 'should return a collection' do
        search_response_none = File.new('spec/fixtures/search/none_results.json')
        stub_request(:get, @expected_request_path).to_return(body: search_response_none, status: 200)
        expect(described_class.search(@sample_searched_text)).to be_kind_of Enumerable
      end

      context 'when server responds with no results' do
        it 'should return an empty collection' do
          search_response_none = File.new('spec/fixtures/search/none_results.json')
          stub_request(:get, @expected_request_path).to_return(body: search_response_none, status: 200)
          expect(described_class.search(@sample_searched_text)).to be_empty
        end
      end

      context 'when server responds with multiple results' do
        it "should return collection of #{described_class} objects" do
          search_response_multiple = File.new('spec/fixtures/search/multiple_results.json')
          stub_request(:get, @expected_request_path).to_return(body: search_response_multiple, status: 200)
          expect(described_class.search(@sample_searched_text)).to all(be_an_instance_of(described_class))
        end
      end
    end
  end
end

