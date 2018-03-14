module OpenAPI::Core
  class Operation
    # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#operationObject

    attr_writer :operation_id, :description, :tags, :security, :parameters, :request_body, :responses

    include Dry::Initializer.define -> do
      option :operation_id, default: proc { '' }
      option :description, default: proc { '' }
      option :tags, default: proc { [] }
      option :security, default: proc { SecurityRequirements.new }
      option :parameters, default: proc { Parameters.new }
      option :request_body, default: proc { RequestBody.new }
      option :responses, default: proc { Responses.new }
    end

    def empty?
      serialize.empty?
    end

    def serialize
      {}.tap do |h|
        h[:operationId] = operation_id if operation_id.present?
        h[:description] = description if description.present?
        h[:tags] = tags unless tags.empty?
        h[:security] = security.serialize unless security.empty?
        h[:parameters] = parameters.serialize unless parameters.empty?
        h[:requestBody] = request_body.serialize unless request_body.empty?
        h[:responses] = responses.serialize unless responses.empty?
      end
    end
  end
end
