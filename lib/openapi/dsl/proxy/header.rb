module OpenAPI::DSL::Proxy
  class Header
    include Defineable
    include SchemaTypes

    def description(value)
      subject.description = value
    end

    def schema(value = nil, &block)
      if value.nil?
        subject.schema = Schema.define(&block)
      else
        subject.schema = value
      end
    end
  end
end
