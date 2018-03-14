module OpenAPI::DSL::Proxy
  class Document
    include Defineable

    def title(value)
      subject.info.title = value
    end

    def version(value)
      subject.info.version = value
    end

    def server(&block)
      subject.servers << Server.define(&block)
    end

    def path(endpoint, value = nil, &block)
      if value.nil?
        subject.paths[endpoint] = PathItem.define(&block)
      else
        subject.paths[endpoint] = value
      end
    end

    def oauth2(description, &block)
      subject.components.security_schemes['OAuth2'] = SecurityScheme.oauth2(description, &block)
    end
  end
end
