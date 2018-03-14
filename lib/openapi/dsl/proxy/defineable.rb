module OpenAPI::DSL::Proxy
  module Defineable
    def self.included(klass)
      klass.extend ClassMethods
      klass.class_eval do
        attr_reader :subject
      end
    end

    def initialize
      @subject = subject_class.new
    end

    def define(&block)
      if block_given?
        case block.arity
        when 0
          Combinder.new(self, block.binding).instance_eval(&block)
        when 1
          yield self
        else
          raise 'Too many args for block'
        end
      end
      subject
    end

    module ClassMethods
      def define(&block)
        new.define(&block)
      end
    end

    protected

    def resolve_values(*values)
      if values.length == 1 && values[0].is_a?(Array)
        values[0]
      else
        values
      end
    end

    def subject_class
      parts = self.class.name.split('::')
      Object.const_get("OpenAPI::Core::#{parts[-1]}")
    end
  end
end
