shared_examples 'a web request' do |request_url|
  describe 'request url' do
    it 'should be valid url' do
      expect(request_url).to be_a_url
    end
  end

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