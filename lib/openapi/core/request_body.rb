module OpenAPI::Core
  class RequestBody
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#request-body-object

    attr_writer :description, :required, :content

    include Dry::Initializer.define -> do
      option :description, default: proc { '' }
      option :required, default: proc { nil } # Boolean
      option :content, default: proc { MediaTypes.new }
    end

    def empty?
      serialize.empty?
    end

    def serialize
      {}.tap do |h|
        h[:description] = description if description.present?
        h[:required] = required unless required.nil?
        h[:content] = content.serialize unless content.empty?
      end
    end
  end
end
