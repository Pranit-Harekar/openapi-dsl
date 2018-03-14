module OpenAPI::Core
  class Components
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#components-object

    attr_writer :security_schemes

    include Dry::Initializer.define -> do
      option :security_schemes, default: proc { SecuritySchemes.new }
    end

    def empty?
      serialize.empty?
    end

    def serialize
      {}.tap do |h|
        h[:securitySchemes] = security_schemes.serialize unless security_schemes.empty?
      end
    end
  end
end
