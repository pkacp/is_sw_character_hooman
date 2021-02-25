require_relative 'sw_api_base'

module SWApi
  class People < SWApiBase
    def self.type
      'people'
    end

    def self.url
      base_url + type
    end
  end
end