module OpenAPI::DSL::Proxy
  class Response
    include Defineable
    include SchemaTypes

    def description(value)
      subject.description = value
    end

    def header(name, value = nil, &block)
      if value.nil?
        subject.headers[name] = Header.define(&block)
      else
        subject.headers[name] = value
      end
    end

    def schema(value = nil, &block)
      if value.nil?
        self.schema = Schema.define(&block)
      else
        self.schema = value
      end
    end

    protected

    def schema=(definition)
      subject.content.add('application/vnd.api+json', schema: definition)
    end
  end
end
