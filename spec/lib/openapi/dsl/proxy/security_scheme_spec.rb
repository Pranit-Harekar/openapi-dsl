RSpec.describe OpenAPI::DSL::Proxy::SecurityScheme do
  let(:security_scheme) { described_class }

  describe 'examples' do
    let(:expected) {
      {
        type: 'oauth2',
        description: 'A description',
        flows: {
          authorizationCode: {
            authorizationUrl: 'https://example.com/oauth/authorize',
            tokenUrl: 'https://example.com/oauth/token',
            scopes: {
              a: 'apple',
              b: 'bat'
            }
          }
        }
      }
    }

    specify {
      scheme = security_scheme.define do
        type 'oauth2'
        description 'A description'
        authorization_code do
          authorization_url 'https://example.com/oauth/authorize'
          token_url 'https://example.com/oauth/token'
          scopes a: 'apple', b: 'bat'
        end
      end

      expect(scheme.serialize).to eq(expected)
    }

    specify {
      scheme = security_scheme.oauth2 'A description' do
        authorization_url 'https://example.com/oauth/authorize'
        token_url 'https://example.com/oauth/token'
        scopes a: 'apple', b: 'bat'
      end

      expect(scheme.serialize).to eq(expected)
    }
  end
end
