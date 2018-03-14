RSpec.describe OpenAPI::DSL::Proxy::OAuthFlow do
  let(:oauth_flow) { described_class }

  describe 'examples' do
    specify {
      flow = oauth_flow.define do
        authorization_url 'https://example.com/oauth/authorize'
        token_url 'https://example.com/oauth/token'
        scopes a: 'apple', b: 'bat'
      end

      expect(flow.serialize).to eq({
        authorizationUrl: 'https://example.com/oauth/authorize',
        tokenUrl: 'https://example.com/oauth/token',
        scopes: {
          a: 'apple',
          b: 'bat'
        }
      })
    }
  end
end
