require_relative 'base_resource'

module SWApi
  class Species < BaseResource
    def self.resource
      'species'
    end

    def self.url
      base_url + resource
    end
  end
end