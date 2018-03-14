module OpenAPI::Core
  class Schema
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#schema-object

    attr_writer :type, :format, :enum
    attr_writer :title, :description
    attr_writer :required, :default
    attr_writer :all_of, :one_of
    attr_writer :properties
    attr_writer :items

    include Dry::Initializer.define -> do
      # Ref https://tools.ietf.org/html/draft-wright-json-schema-validation-00

      option :type, default: proc { '' }
      option :format, default: proc { '' }
      option :enum, default: proc { [] }

      option :title, default: proc { '' }
      option :description, default: proc { '' }

      option :required, default: proc { [] }
      option :default, default: proc { nil }

      option :all_of, default: proc { SchemaArray.new }
      option :one_of, default: proc { SchemaArray.new }

      # when type == 'object'
      option :properties, default: proc { SchemaHash.new }

      # when type == 'array'
      option :items, default: proc { nil } # Schema
    end

    # This method would ensure that a schema conforms to the spec.
    #
    # It would return an validation object that either indicates:
    # 1. Success => it conforms
    # 2. Failure => it doesn't conform and so it has errors indicating what's wrong
    #
    # def validate
    #
    # end

    def empty?
      serialize.empty?
    end

    def serialize
      {}.tap do |h|
        h[:type] = type if type.present?
        h[:format] = format if format.present?
        h[:enum] = enum unless enum.empty?

        h[:title] = title if title.present?
        h[:description] = description if description.present?

        h[:required] = required unless required.empty?
        h[:default] = default unless default.nil?

        h[:allOf] = all_of.serialize unless all_of.empty?
        h[:oneOf] = one_of.serialize unless one_of.empty?

        h[:properties] = properties.serialize unless properties.empty?

        h[:items] = items.serialize unless items.nil?
      end
    end
  end
end
