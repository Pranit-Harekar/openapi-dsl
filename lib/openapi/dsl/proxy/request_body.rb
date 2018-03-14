module OpenAPI::DSL::Proxy
  class RequestBody
    include Defineable
    include SchemaTypes

    def description(value)
      subject.description = value
    end

    def required(value)
      subject.required = value
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
