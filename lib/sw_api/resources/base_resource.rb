module SWApi
  class BaseResource
    def self.search(text)
      raise NotImplementedError # TODO implement this method here as factory deciding form server response which object should be built
    end

    protected

    def self.resource
      raise NotImplementedError
    end

    def self.base_url
      'https://swapi.dev/api/'
    end

    def self.search_specifier
      '?search='
    end
  end
end