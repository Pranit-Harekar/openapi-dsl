module OpenAPI::Core
  class Response
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#response-object

    attr_writer :description, :headers, :content

    include Dry::Initializer.define -> do
      option :description, default: proc { '' }
      option :headers, default: proc { Headers.new }
      option :content, default: proc { MediaTypes.new }
    end

    def empty?
      serialize.empty?
    end

    def serialize
      {}.tap do |h|
        h[:description] = description if description.present?
        h[:headers] = headers.serialize unless headers.empty?
        h[:content] = content.serialize unless content.empty?
      end
    end
  end
end
