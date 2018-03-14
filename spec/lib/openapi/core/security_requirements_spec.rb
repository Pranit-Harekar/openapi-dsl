RSpec.describe OpenAPI::Core::SecurityRequirements do
  describe '#serialize' do
    specify {
      subject.add(name: 'oauth2', scopes: ['read', 'write'])
      subject.add(name: 'api_key')

      expect(subject.serialize).to eq([
        { 'oauth2' => ['read', 'write'] },
        { 'api_key' => [] }
      ])
    }
  end
end
