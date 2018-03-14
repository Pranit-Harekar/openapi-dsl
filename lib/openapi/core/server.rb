module OpenAPI::Core
  class Server
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#serverObject

    attr_writer :url, :description, :variables

    include Dry::Initializer.define -> do
      option :url, default: proc { '' }
      option :description, default: proc { '' }
      option :variables, default: proc { ServerVariables.new }
    end

    def empty?
      serialize.empty?
    end

    def serialize
      {}.tap do |h|
        h[:url] = url if url.present?
        h[:description] = description if description.present?
        h[:variables] = variables.serialize unless variables.empty?
      end
    end
  end
end
