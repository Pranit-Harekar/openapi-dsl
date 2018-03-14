module OpenAPI::Core
  class OAuthFlow
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#oauth-flow-object

    attr_writer :authorization_url, :token_url, :scopes

    include Dry::Initializer.define -> do
      option :authorization_url, default: proc { '' }
      option :token_url, default: proc { '' }
      option :scopes, default: proc { {} }
    end

    def empty?
      serialize.empty?
    end

    def serialize
      {}.tap do |h|
        h[:authorizationUrl] = authorization_url if authorization_url.present?
        h[:tokenUrl] = token_url if token_url.present?
        h[:scopes] = scopes unless scopes.empty?
      end
    end
  end
end
