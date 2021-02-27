module SWApi
  class SWApiBase
    def self.base_url
      'https://swapi.dev/api/'
    end

    def self.resource
      raise NotImplementedError
    end

    def self.search(text)

    end

  end
end