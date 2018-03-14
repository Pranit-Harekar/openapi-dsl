module OpenAPI::DSL::Proxy
  class SecurityRequirement
    include Defineable

    class << self
      def oauth2(*values)
        define do
          name 'OAuth2'
          scopes *values
        end
      end
    end

    def name(value)
      subject.name = value
    end

    def scopes(*values)
      subject.scopes = resolve_values(*values)
    end
  end
end
