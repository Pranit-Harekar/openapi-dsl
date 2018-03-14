RSpec.describe OpenAPI::DSL::Proxy::Parameter do
  let(:parameter) { described_class }
  let(:schema) { OpenAPI::DSL::Proxy::Schema }

  describe 'parameter object properties' do
    describe 'name' do
      specify {
        expect(parameter.define { name 'include' }.serialize).to eq({
          name: 'include'
        })
      }
    end

    describe 'in' do
      specify {
        expect(parameter.define { in_ 'query' }.serialize).to eq({
          in: 'query'
        })
      }
    end

    describe 'description' do
      specify {
        expect(parameter.define { description 'A comma-separated list of relationships to include in the response.' }.serialize).to eq({
          description: 'A comma-separated list of relationships to include in the response.'
        })
      }
    end

    describe 'required' do
      specify {
        expect(parameter.define { required true }.serialize).to eq({
          required: true
        })
      }
    end

    describe 'schema' do
      context 'inline' do
        specify {
          expect(parameter.define {
            schema { type 'string' }
          }.serialize).to eq({
            schema: {
              type: 'string'
            }
          })
        }
      end

      context 'external' do
        specify {
          page = schema.long { default 1 }
          result = parameter.define do
            schema page
          end

          expect(result.serialize).to eq({
            schema: {
              type: 'integer',
              format: 'int64',
              default: 1
            }
          })
        }
      end
    end
  end

  describe 'shortcuts' do
    describe 'query' do
      specify {
        q = parameter.query do
          name 'include'
          description 'A comma-separated list of relationships to include in the response.'
        end

        expect(q.serialize).to eq({
          name: 'include',
          description: 'A comma-separated list of relationships to include in the response.',
          in: 'query',
          schema: {
            type: 'string'
          }
        })
      }
    end
  end

  describe 'examples' do
    describe 'page number' do
      specify {
        page_number = parameter.query do
          name 'page[number]'
          description "The collection's page number to return."
          schema {
            type 'integer'
            default 1
          }
        end

        expect(page_number.serialize).to eq({
          name: 'page[number]',
          in: 'query',
          description: "The collection's page number to return.",
          schema: {
            type: 'integer',
            default: 1
          }
        })
      }
    end

    describe 'page size' do
      specify {
        page_size = parameter.query do
          name 'page[size]'
          description 'The number of collection items to return per page.'
          integer { default 10 }
        end

        expect(page_size.serialize).to eq({
          name: 'page[size]',
          in: 'query',
          description: 'The number of collection items to return per page.',
          schema: {
            type: 'integer',
            format: 'int32',
            default: 10
          }
        })
      }
    end
  end
end
