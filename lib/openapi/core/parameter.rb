module OpenAPI::Core
  class Parameter
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#parameter-object

    attr_writer :name, :in_, :description, :required, :schema

    include Dry::Initializer.define -> do
      option :name, default: proc { '' }
      option :in_, default: proc { '' }
      option :description, default: proc { '' }
      option :required, default: proc { nil } # Boolean
      option :schema, default: proc { nil } # Schema
    end

    def empty?
      serialize.empty?
    end

    def serialize
      {}.tap do |h|
        h[:name] = name if name.present?
        h[:in] = in_ if in_.present?
        h[:description] = description if description.present?
        h[:required] = required unless required.nil?
        h[:schema] = schema.serialize unless schema.nil?
      end
    end
  end
end
