module OpenAPI::Core
  class OAuthFlows
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#oauth-flows-object

    attr_writer :authorization_code

    include Dry::Initializer.define -> do
      option :authorization_code, default: proc { OAuthFlow.new }
    end

    def empty?
      serialize.empty?
    end

    def serialize
      {}.tap do |h|
        h[:authorizationCode] = authorization_code.serialize unless authorization_code.empty?
      end
    end
  end
end
