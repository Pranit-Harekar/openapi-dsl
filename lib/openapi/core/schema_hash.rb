module OpenAPI::Core
  class SchemaHash < AbstractHash
    protected

    def value_class
      Schema
    end
  end
end
