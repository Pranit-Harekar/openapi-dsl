RSpec.describe OpenAPI::DSL::Proxy::Operation do
  let(:operation) { described_class }

  describe 'examples' do
    specify {
      result = operation.define do
        operation_id 'id'
        description 'A description'
        tags %w(a b c)
        oauth2 %w(x y z)
        parameter do
          name 'page'
          integer { default 1 }
        end
      end

      expect(result.serialize).to eq({
        operationId: 'id',
        description: 'A description',
        tags: %w(a b c),
        security: [
          { 'OAuth2' => %w(x y z) }
        ],
        parameters: [
          {
            name: 'page',
            schema: {
              type: 'integer',
              format: 'int32',
              default: 1
            }
          }
        ]
      })
    }
  end
end
