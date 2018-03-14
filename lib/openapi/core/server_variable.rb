module OpenAPI::Core
  class ServerVariable
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#server-variable-object

    attr_writer :default, :description

    include Dry::Initializer.define -> do
      option :default, default: proc { '' }
      option :description, default: proc { '' }
    end

    def empty?
      serialize.empty?
    end

    def serialize
      {}.tap do |h|
        h[:default] = default if default.present?
        h[:description] = description if description.present?
      end
    end
  end
end
