module OpenAPI::Core
  class MediaType
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#media-type-object

    attr_writer :schema

    include Dry::Initializer.define -> do
      option :schema, default: proc { Schema.new }
    end

    def empty?
      serialize.empty?
    end

    def serialize
      {}.tap do |h|
        h[:schema] = schema.serialize unless schema.empty?
      end
    end
  end
end
