require_relative '../lib/http_connector.rb'

RSpec.describe HttpConnector do
  describe '.new' do
    it 'should take one parameter' do
      expect(described_class).to respond_to(:new).with(1).argument
    end
  end

  describe '#get' do
    let(:sample_url) { "https://swapi.dev/api/people/1/" }
    let(:response_body) { File.read('spec/fixtures/link/people.json') }
    let(:response) { instance_double(HTTParty::Response, body: response_body) }

    subject { described_class.new(sample_url) }

    context 'when everything is ok' do
      before do
        allow(HTTParty).to receive(:get).and_return(response)
        allow(JSON).to receive(:parse).and_return(Hash.new)
      end

      it 'should call HTTParty.get once' do
        subject.get
        expect(HTTParty).to have_received(:get).with(sample_url)
      end

      it 'should call JSON.parse once' do
        subject.get
        expect(JSON).to have_received(:parse).with(response_body)
      end

      it 'should return Hash object' do
        response = subject.get
        expect(response).to be_an_instance_of(Hash)
      end
    end

    context 'when incorrect url' do
      before do
        allow(HTTParty).to receive(:get).and_raise(HTTParty::UnsupportedURIScheme.new('error'))
      end

      it 'should raise IncorrectURL when HTTParty raises UnsupportedURIScheme' do
        expect{subject.get}.to raise_error(SWApi::Connector::IncorrectURL)
      end
    end

    context 'response error' do
      before do
        allow(HTTParty).to receive(:get).and_raise(HTTParty::ResponseError.new('error'))
      end

      it 'should raise IncorrectResponse when Httparty raises ResponseError' do
        expect{subject.get}.to raise_error(SWApi::Connector::IncorrectResponse)
      end
    end

    context 'unsupported web response format' do
      before do
        allow(HTTParty).to receive(:get).and_raise(HTTParty::UnsupportedFormat.new('error'))
      end

      it 'should raise IncorrectFormat when Httparty raises IncorrectFormat' do
        expect{subject.get}.to raise_error(SWApi::Connector::IncorrectFormat)
      end
    end

    context 'when other HTTParty error' do
      before do
        allow(HTTParty).to receive(:get).and_return(HTTParty::Error.new('error'))
      end

      it 'should raise ParsingToHashError when JSON raises ParserError' do
        expect{subject.get}.to raise_error(SWApi::Connector::OtherHTTPartyError)
      end
    end

    context 'when json parse error' do
      before do
        allow(HTTParty).to receive(:get).and_return('fake_response')
        allow(JSON).to receive(:parse).and_return(JSON::ParserError.new('error'))
      end

      it 'should raise ParsingToHashError when JSON raises ParserError' do
        expect{subject.get}.to raise_error(SWApi::Connector::ParsingToHashError)
      end
    end

    context 'when other JSON error' do
      before do
        allow(HTTParty).to receive(:get).and_return('fake_response')
        allow(JSON).to receive(:parse).and_return(JSON::JSONError.new('error'))
      end

      it 'should raise ParsingToHashError when JSON raises ParserError' do
        expect{subject.get}.to raise_error(SWApi::Connector::OtherJSONError)
      end
    end
  end
end