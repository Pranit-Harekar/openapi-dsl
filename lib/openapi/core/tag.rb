module OpenAPI::Core
  class Tag
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#tagObject

    attr_writer :name, :description

    include Dry::Initializer.define -> do
      option :name, default: proc { '' }
      option :description, default: proc { '' }
    end

    def empty?
      serialize.empty?
    end

    def serialize
      {}.tap do |h|
        h[:name] = name if name.present?
        h[:description] = description if description.present?
      end
    end
  end
end
