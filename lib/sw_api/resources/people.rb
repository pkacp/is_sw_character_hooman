require_relative 'base_resource'

module SWApi
  class People < BaseResource
    def self.resource
      'people'
    end

    def self.url
      base_url + resource
    end
  end
end