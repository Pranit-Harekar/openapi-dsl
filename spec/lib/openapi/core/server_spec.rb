RSpec.describe OpenAPI::Core::Server do
  let(:url) { Faker::Internet.url }
  let(:description) { Faker::Lorem.sentence }

  subject { described_class.new(url: url, description: description) }

  context 'with variables' do
    let(:name) { Faker::Lorem.word }
    let(:default) { Faker::Lorem.word }

    before do
      subject.variables.add(name, default: default)
    end

    specify { expect(subject.variables[name].default).to eq(default) }

    describe '#serialize' do
      specify {
        expected = {
          url: url,
          description: description,
          variables: {
            name => { default: default }
          }
        }

        expect(subject.serialize).to eq(expected)
      }
    end
  end
end
