module OpenAPI::Core
  class SecurityScheme
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#security-scheme-object

    attr_writer :type, :description, :flows

    include Dry::Initializer.define -> do
      option :type, default: proc { '' }
      option :description, default: proc { '' }
      option :flows, default: proc { OAuthFlows.new }
    end

    def empty?
      serialize.empty?
    end

    def serialize
      {}.tap do |h|
        h[:type] = type if type.present?
        h[:description] = description if description.present?
        h[:flows] = flows.serialize unless flows.empty?
      end
    end
  end
end
