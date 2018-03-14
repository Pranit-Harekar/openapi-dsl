module OpenAPI::DSL::Proxy
  class Server
    include Defineable

    def url(value)
      subject.url = value
    end

    def description(value)
      subject.description = value
    end

    def variable(name, &block)
      subject.variables[name] = ServerVariable.define(&block)
    end
  end
end
