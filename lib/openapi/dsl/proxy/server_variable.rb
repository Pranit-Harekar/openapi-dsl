module OpenAPI::DSL::Proxy
  class ServerVariable
    include Defineable

    def default(value)
      subject.default = value
    end

    def description(value)
      subject.description = value
    end
  end
end
