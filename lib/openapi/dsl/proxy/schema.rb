module OpenAPI::DSL::Proxy
  class Schema
    include Defineable

    class << self
      def string(&block)
        new.string(&block)
      end

      def integer(&block)
        new.integer(&block)
      end

      def long(&block)
        new.long(&block)
      end

      def float(&block)
        new.float(&block)
      end

      def double(&block)
        new.double(&block)
      end

      def byte(&block)
        new.byte(&block)
      end

      def binary(&block)
        new.binary(&block)
      end

      def boolean(&block)
        new.boolean(&block)
      end

      def date(&block)
        new.date(&block)
      end

      def datetime(&block)
        new.datetime(&block)
      end

      def password(&block)
        new.password(&block)
      end

      def object(&block)
        new.object(&block)
      end

      def array(of:, &block)
        new.array(of: of, &block)
      end
    end

    def type(value)
      subject.type = value
    end

    def format(value)
      subject.format = value
    end

    def enum(*values)
      subject.enum = resolve_values(*values)
    end

    def title(value)
      subject.title = value
    end

    def description(value)
      subject.description = value
    end

    def required(*values)
      subject.required = resolve_values(*values)
    end

    def default(value)
      subject.default = value
    end

    def all_of(*schemas)
      schemas.each { |schema| subject.all_of << schema }
      subject.all_of
    end

    def one_of(*schemas)
      schemas.each { |schema| subject.one_of << schema }
      subject.one_of
    end

    def properties(**props)
      props.each { |(name, schema)| subject.properties[name] = schema }
      subject.properties
    end

    def property(name, schema)
      subject.properties[name] = schema
    end

    def items(of)
      subject.items = of
    end

    def schema(&block)
      self.class.new.define(&block)
    end

    def string(&block)
      schema(&block).tap do |s|
        s.type = 'string'
      end
    end

    def integer(&block)
      schema(&block).tap do |s|
        s.type = 'integer'
        s.format = 'int32'
      end
    end

    def long(&block)
      schema(&block).tap do |s|
        s.type = 'integer'
        s.format = 'int64'
      end
    end

    def float(&block)
      schema(&block).tap do |s|
        s.type = 'number'
        s.format = 'float'
      end
    end

    def double(&block)
      schema(&block).tap do |s|
        s.type = 'number'
        s.format = 'double'
      end
    end

    def byte(&block)
      schema(&block).tap do |s|
        s.type = 'string'
        s.format = 'byte'
      end
    end

    def binary(&block)
      schema(&block).tap do |s|
        s.type = 'string'
        s.format = 'binary'
      end
    end

    def boolean(&block)
      schema(&block).tap do |s|
        s.type = 'boolean'
      end
    end

    def date(&block)
      schema(&block).tap do |s|
        s.type = 'string'
        s.format = 'date'
      end
    end

    def datetime(&block)
      schema(&block).tap do |s|
        s.type = 'string'
        s.format = 'date-time'
      end
    end

    def password(&block)
      schema(&block).tap do |s|
        s.type = 'string'
        s.format = 'password'
      end
    end

    def object(&block)
      schema(&block).tap do |s|
        s.type = 'object'
      end
    end

    def array(of:, &block)
      schema(&block).tap do |s|
        s.type = 'array'
        s.items = of
      end
    end
  end
end
