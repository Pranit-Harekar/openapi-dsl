module OpenAPI::DSL::Proxy
  class OAuthFlow
    include Defineable

    def authorization_url(value)
      subject.authorization_url = value
    end

    def token_url(value)
      subject.token_url = value
    end

    def scopes(values)
      subject.scopes = values
    end
  end
end
