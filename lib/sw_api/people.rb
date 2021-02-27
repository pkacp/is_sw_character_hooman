require_relative 'sw_api_base'

module SWApi
  class People < SWApiBase
    def self.resource
      'people'
    end

    def self.url
      base_url + resource
    end
  end
end