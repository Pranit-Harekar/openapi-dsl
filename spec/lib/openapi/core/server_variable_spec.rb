RSpec.describe OpenAPI::Core::ServerVariable do
  let(:default) { Faker::Lorem.word }
  let(:description) { Faker::Lorem.sentence }

  context 'with default' do
    subject { described_class.new(default: default) }

    specify { expect(subject.default).to eq(default) }
    specify { expect(subject.description).to be_empty }

    describe '#serialize' do
      specify {
        expected = {
          default: default
        }

        expect(subject.serialize).to eq(expected)
      }
    end
  end

  context 'with default and description' do
    subject { described_class.new(default: default, description: description) }

    specify { expect(subject.default).to eq(default) }
    specify { expect(subject.description).to eq(description) }

    describe '#serialize' do
      specify {
        expected = {
          default: default,
          description: description
        }

        expect(subject.serialize).to eq(expected)
      }
    end
  end
end
