RSpec.describe OpenAPI::DSL::Proxy::Document do
  let(:document) { described_class }

  describe 'examples' do
    specify {
      doc = document.define do
        title 'Springboard Retail API'
        version '2.0.0'

        server do
          url 'https://{tenant}.myspringboard.us/api/v2'
          variable 'tenant' do
            default 'demo'
            description "Tenant's subdomain"
          end
        end

        oauth2 'This API uses OAuth 2. [More info](https://api.example.com/docs/auth)' do
          authorization_url 'https://myspringboard.us/oauth/authorize'
          token_url 'https://myspringboard.us/api/oauth/token'
          scopes a: 'apple', b: 'bat', c: 'cat'
        end
      end

      expect(doc.serialize).to eq({
        openapi: OpenAPI::VERSION,
        info: {
          title: 'Springboard Retail API',
          version: '2.0.0'
        },
        servers: [
          {
            url: 'https://{tenant}.myspringboard.us/api/v2',
            variables: {
              'tenant' => {
                default: 'demo',
                description: "Tenant's subdomain"
              }
            }
          }
        ],
        components: {
          securitySchemes: {
            'OAuth2' => {
              type: 'oauth2',
              description: 'This API uses OAuth 2. [More info](https://api.example.com/docs/auth)',
              flows: {
                authorizationCode: {
                  authorizationUrl: 'https://myspringboard.us/oauth/authorize',
                  tokenUrl: 'https://myspringboard.us/api/oauth/token',
                  scopes: {
                    a: 'apple',
                    b: 'bat',
                    c: 'cat'
                  }
                }
              }
            }
          }
        }
      })
    }
  end
end
