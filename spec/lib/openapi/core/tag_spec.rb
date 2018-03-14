RSpec.describe OpenAPI::Core::Tag do
  describe '#serialize' do
    specify {
      name = Faker::Lorem.word
      description = Faker::Lorem.sentence

      tag = described_class.new(name: name, description: description)

      expect(tag.serialize).to eq({
        name: name,
        description: description
      })
    }
  end
end
