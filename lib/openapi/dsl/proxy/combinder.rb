module OpenAPI::DSL::Proxy
  class Combinder < BasicObject
    def initialize(obj, saved_binding)
      @obj = obj
      @saved_binding = saved_binding
    end

    def __bound_self__
      @saved_binding.eval('self')
    end

    def method_missing(m, *args, &block)
      if @obj.respond_to?(m)
        @obj.send(m, *args, &block)
      else
        __bound_self__.send(m, *args, &block)
      end
    end

    def respond_to_missing?(m, include_all)
      return __bound_self__.respond_to?(m) || @obj.respond_to?(m)
    end
  end
end
