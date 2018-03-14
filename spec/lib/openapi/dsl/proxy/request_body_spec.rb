RSpec.describe OpenAPI::DSL::Proxy::RequestBody do
  let(:body) { described_class }
  let(:schema) { OpenAPI::DSL::Proxy::Schema }

  describe 'examples' do
    specify {
      number = schema.integer { default 5 }

      result = body.define do
        description 'A description'
        required true
        schema number
      end

      expect(result.serialize).to eq({
        description: 'A description',
        required: true,
        content: {
          'application/vnd.api+json' => {
            schema: {
              type: 'integer',
              format: 'int32',
              default: 5
            }
          }
        }
      })
    }
  end
end
