RSpec.describe OpenAPI::DSL::Proxy::PathItem do
  let(:path) { described_class }

  describe 'examples' do
    specify {
      result = path.define do
        get {}
        post {}
        delete {}
        put {}
        patch {}
      end

      expect(result.serialize).to eq({})
    }
  end
end
