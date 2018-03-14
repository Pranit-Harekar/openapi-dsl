module OpenAPI::Core
  class Servers < AbstractArray
    protected

    def serialize_empty
      [ element_class.new(url: '/').serialize ]
    end
  end
end
