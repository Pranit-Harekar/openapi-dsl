module OpenAPI::DSL::Proxy
  class PathItem
    include Defineable

    def get(&block)
      subject.get = Operation.define(&block)
    end

    def post(&block)
      subject.post = Operation.define(&block)
    end

    def delete(&block)
      subject.delete = Operation.define(&block)
    end

    def put(&block)
      subject.put = Operation.define(&block)
    end

    def patch(&block)
      subject.patch = Operation.define(&block)
    end
  end
end
