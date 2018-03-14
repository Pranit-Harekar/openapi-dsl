module OpenAPI::DSL::Proxy
  class Tag
    include Defineable

    def name(value)
      subject.name = value
    end

    def description(value)
      subject.description = value
    end
  end
end
