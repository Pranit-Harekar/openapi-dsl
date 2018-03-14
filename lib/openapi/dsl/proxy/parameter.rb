module OpenAPI::DSL::Proxy
  class Parameter
    include Defineable
    include SchemaTypes

    class << self
      def path(&block)
        new.path(&block)
      end

      def query(&block)
        new.query(&block)
      end
    end

    def path(&block)
      define(&block).tap do |p|
        p.in_ = 'path'
        p.schema = Schema.string unless p.schema.present?
      end
    end

    def query(&block)
      define(&block).tap do |p|
        p.in_ = 'query'
        p.schema = Schema.string unless p.schema.present?
      end
    end

    def name(value)
      subject.name = value
    end

    def in_(value)
      subject.in_ = value
    end

    def description(value)
      subject.description = value
    end

    def required(value)
      subject.required = value
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
