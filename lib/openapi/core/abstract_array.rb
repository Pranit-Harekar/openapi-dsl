module OpenAPI::Core
  class AbstractArray < Array
    def add(**kwargs)
      element_class.new(**kwargs).tap do |elem|
        self << elem
      end
    end

    def serialize
      if empty?
        serialize_empty
      else
        serialize_non_empty
      end
    end

    protected

    def element_class
      parts = self.class.name.split('::')
      parts[-1] = parts[-1].chomp('s')
      Object.const_get(parts.join('::'))
    end

    def serialize_empty
      []
    end

    def serialize_non_empty
      map(&:serialize)
    end
  end
end
