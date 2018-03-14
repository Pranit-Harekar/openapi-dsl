RSpec.describe OpenAPI::DSL::Proxy::SecurityRequirement do
  let(:security_requirement) { described_class }

  describe 'security requirement object properties' do
    describe 'name' do
      specify {
        expect(security_requirement.define { name 'api_key' }.serialize).to eq({
          'api_key' => []
        })
      }
    end

    describe 'scopes' do
      specify {
        expect(security_requirement.define do
          name 'OAuth2'
          scopes 'a', 'b', 'c'
        end.serialize).to eq({
          'OAuth2' => %w(a b c)
        })
      }

      specify {
        expect(security_requirement.define do
          name 'OAuth2'
          scopes %w(a b c)
        end.serialize).to eq({
          'OAuth2' => %w(a b c)
        })
      }
    end
  end

  describe 'shortcuts' do
    describe 'oauth2' do
      specify {
        oauth2 = security_requirement.oauth2 'a', 'b', 'c'

        expect(oauth2.serialize).to eq({
          'OAuth2' => %w(a b c)
        })
      }

      specify {
        oauth2 = security_requirement.oauth2 %w(a b c)

        expect(oauth2.serialize).to eq({
          'OAuth2' => %w(a b c)
        })
      }
    end
  end
end
