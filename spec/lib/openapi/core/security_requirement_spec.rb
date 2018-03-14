RSpec.describe OpenAPI::Core::SecurityRequirement do
  let(:name) { 'oauth2' }
  let(:scopes) { ['read', 'write'] }

  describe '#serialize' do
    context 'with neither name nor scopes' do
      subject { described_class.new }

      specify {
        expect(subject.serialize).to eq({})
      }
    end

    context 'with name' do
      subject { described_class.new(name: name) }

      specify {
        expect(subject.serialize).to eq({ name => [] })
      }
    end

    context 'with name and scopes' do
      subject { described_class.new(name: name, scopes: scopes) }

      specify {
        expect(subject.serialize).to eq({ name => scopes })
      }
    end
  end
end
