require_relative '../lib/http_connector.rbor'

RSpec.describe HttpConnector do
  describe '.new' do
    let(:incorrect_url) { ".,m.////;'??&'" }

    it 'should take one parameter' do
      it {is_expected.to respond_to(:new).with(1).argument}
    end

    it 'should raise ArgumentError if parameter is incorrect url' do
      expect{described_class.new(incorrect_url)}.to raise_error(ArgumentError)
    end
  end

  describe '#get' do
    let(:sample_url) { "https://swapi.dev/api/people/1/" }
    let(:response_body) { File.read('spec/fixtures/link/people.json') }
    let(:response) { instance_double(HTTParty::Response, body: response_body) }

    before do
      allow(HTTParty).to receive(:get).and_return(response)
      allow(JSON).to receive(:parse)

      subject { described_class.new(sample_url)}
    end

    it 'should call HTTParty.get once' do
      subject.get
      expect(HTTParty).to have_received(:get).with(github_url)
    end

    it 'should call JSON.parse once' do
      subject.get
      expect(JSON).to have_received(:parse).with(response_body)
    end
  end
end