require_relative '../lib/http_connector.rb'

RSpec.describe HttpConnector do
  describe '.new' do
    let(:incorrect_url) { ".,m.////;'??&'" }

    it 'should take one parameter' do
      expect(described_class).to respond_to(:new).with(1).argument
    end
  end

  describe '#get' do
    let(:sample_url) { "https://swapi.dev/api/people/1/" }
    let(:response_body) { File.read('spec/fixtures/link/people.json') }
    let(:response) { instance_double(HTTParty::Response, body: response_body) }

    before do
      allow(HTTParty).to receive(:get).and_return(response)
      allow(JSON).to receive(:parse).and_return(Hash.new)
    end

    subject { described_class.new(sample_url) }

    it 'should call HTTParty.get once' do
      subject.get
      expect(HTTParty).to have_received(:get).with(sample_url)
    end

    context 'when everything is ok' do
      it 'should call JSON.parse once' do
        subject.get
        expect(JSON).to have_received(:parse).with(response_body)
      end

      it 'should return Hash object' do
        response = subject.get
        expect(response).to be_an_instance_of(Hash)
      end
    end
  end
end