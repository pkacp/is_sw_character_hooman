require 'httparty'
require 'json'

class HttpConnector
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def get
    res = HTTParty.get(url)
    JSON.parse(res.body)
  end
end