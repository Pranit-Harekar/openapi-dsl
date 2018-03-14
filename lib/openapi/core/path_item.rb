module OpenAPI::Core
  class PathItem
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#path-item-object

    OPERATIONS = %i(get post delete put patch)

    attr_writer *OPERATIONS

    include Dry::Initializer.define -> do
      option :get, default: proc { Operation.new }
      option :post, default: proc { Operation.new }
      option :delete, default: proc { Operation.new }
      option :put, default: proc { Operation.new }
      option :patch, default: proc { Operation.new }
    end

    def empty?
      serialize.empty?
    end

    def serialize
      {}.tap do |h|
        OPERATIONS.each do |op|
          v = public_send(op)
          h[op] = v.serialize unless v.empty?
        end
      end
    end
  end
end
