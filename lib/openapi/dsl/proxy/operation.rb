module OpenAPI::DSL::Proxy
  class Operation
    include Defineable

    def operation_id(value)
      subject.operation_id = value
    end

    def description(value)
      subject.description = value
    end

    def tags(*values)
      subject.tags = resolve_values(*values)
    end

    def oauth2(*value)
      subject.security << SecurityRequirement.oauth2(*value)
    end

    def parameters(*values)
      values.each do |value|
        subject.parameters << value
      end
    end

    def parameter(value = nil, &block)
      if value.nil?
        subject.parameters << Parameter.define(&block)
      else
        subject.parameters << value
      end
    end

    def path_parameter(&block)
      subject.parameters << Parameter.path(&block)
    end

    def query_parameter(&block)
      subject.parameters << Parameter.query(&block)
    end

    def response(code, value = nil, &block)
      if value.nil?
        subject.responses[code] = Response.define(&block)
      else
        subject.responses[code] = value
      end
    end

    def default_response(value = nil, &block)
      response('default', value, &block)
    end

    def request_body(&block)
      subject.request_body = RequestBody.define(&block)
    end
  end
end
