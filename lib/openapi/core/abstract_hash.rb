module OpenAPI::Core
  class AbstractHash < Hash
    def add(key, **kwargs)
      self[key] = value_class.new(**kwargs)
    end

    def serialize
      each_with_object({}) do |(k, v), h|
        h[k] = v.serialize
        h
      end
    end

    protected

    def value_class
      parts = self.class.name.split('::')
      parts[-1] = parts[-1].chomp('s')
      Object.const_get(parts.join('::'))
    end
  end
end
