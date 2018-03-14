RSpec.describe OpenAPI::Core::Info do
  describe '#serialize' do
    specify {
      title = 'Awesome API'
      version = '1.0.0'

      info = described_class.new(title: title, version: version)

      expect(info.serialize).to eq({
        title: title,
        version: version
      })
    }
  end
end
