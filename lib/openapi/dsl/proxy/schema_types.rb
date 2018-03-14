module OpenAPI::DSL::Proxy
  module SchemaTypes
    def string(&block)
      self.schema = Schema.string(&block)
    end

    def integer(&block)
      self.schema = Schema.integer(&block)
    end

    def long(&block)
      self.schema = Schema.long(&block)
    end

    def float(&block)
      self.schema = Schema.float(&block)
    end

    def double(&block)
      self.schema = Schema.double(&block)
    end

    def byte(&block)
      self.schema = Schema.byte(&block)
    end

    def binary(&block)
      self.schema = Schema.binary(&block)
    end

    def boolean(&block)
      self.schema = Schema.boolean(&block)
    end

    def date(&block)
      self.schema = Schema.date(&block)
    end

    def datetime(&block)
      self.schema = Schema.datetime(&block)
    end

    def password(&block)
      self.schema = Schema.password(&block)
    end

    def object(&block)
      self.schema = Schema.object(&block)
    end

    def array(of:, &block)
      self.schema = Schema.array(of: of, &block)
    end

    protected

    def schema=(definition)
      subject.schema = definition
    end
  end
end
