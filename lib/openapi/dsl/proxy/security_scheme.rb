module OpenAPI::DSL::Proxy
  class SecurityScheme
    include Defineable

    class << self
      def oauth2(description, &block)
        OpenAPI::Core::SecurityScheme.new.tap do |subject|
          subject.type = 'oauth2'
          subject.description = description
          subject.flows.authorization_code = OAuthFlow.define(&block)
        end
      end
    end

    def type(value)
      subject.type = value
    end

    def description(value)
      subject.description = value
    end

    def authorization_code(&block)
      subject.flows.authorization_code = OAuthFlow.define(&block)
    end
  end
end
