RSpec.describe OpenAPI::Core::Servers do
  describe '#serialize' do
    context 'when empty' do
      specify {
        expect(subject.serialize).to eq([{ url: '/' }])
      }
    end

    context 'when non-empty' do
      specify {
        name = Faker::Lorem.word
        url = "https://{#{name}}.example.com/api"
        default = Faker::Lorem.word
        description = Faker::Lorem.sentence

        subject \
          .add(url: url)
          .variables
          .add(name, default: default, description: description)

        expected = [
          {
            url: url,
            variables: {
              name => {
                default: default,
                description: description
              }
            }
          }
        ]

        expect(subject.serialize).to eq(expected)
      }
    end
  end
end
