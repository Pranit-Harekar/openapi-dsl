module OpenAPI::Core
  class Header
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#header-object

    attr_writer :description, :schema

    include Dry::Initializer.define -> do
      option :description, default: proc { '' }
      option :schema, default: proc { Schema.new }
    end

    def empty?
      serialize.empty?
    end

    def serialize
      {}.tap do |h|
        h[:description] = description if description.present?
        h[:schema] = schema.serialize unless schema.empty?
      end
    end
  end
end
