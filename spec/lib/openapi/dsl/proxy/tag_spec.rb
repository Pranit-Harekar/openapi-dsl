RSpec.describe OpenAPI::DSL::Proxy::Tag do
  let(:tag) { described_class }

  describe 'examples' do
    specify {
      result = tag.define do
        name 'A name'
        description 'A description'
      end

      expect(result.serialize).to eq({
        name: 'A name',
        description: 'A description'
      })
    }
  end
end
