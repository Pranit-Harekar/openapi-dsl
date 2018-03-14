module OpenAPI::Core
  class SecurityRequirement
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#security-requirement-object

    attr_writer :name, :scopes

    include Dry::Initializer.define -> do
      option :name, default: proc { '' }
      option :scopes, default: proc { [] }
    end

    def empty?
      serialize.empty?
    end

    def serialize
      {}.tap do |h|
        h[name] = scopes if name.present?
      end
    end
  end
end
