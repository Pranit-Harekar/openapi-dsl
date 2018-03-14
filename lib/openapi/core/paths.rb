module OpenAPI::Core
  class Paths < AbstractHash
    protected

    def value_class
      PathItem
    end
  end
end
