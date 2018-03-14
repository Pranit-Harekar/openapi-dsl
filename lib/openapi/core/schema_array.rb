module OpenAPI::Core
  class SchemaArray < AbstractArray
    protected

    def element_class
      Schema
    end
  end
end
