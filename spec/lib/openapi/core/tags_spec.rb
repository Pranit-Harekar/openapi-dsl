RSpec.describe OpenAPI::Core::Tags do
  describe '#serialize' do
    specify {
      names = [ Faker::Lorem.word, Faker::Lorem.word ]
      description = Faker::Lorem.sentence

      subject.add(name: names[0])
      subject.add(name: names[1], description: description)

      expect(subject.serialize).to eq([
        { name: names[0] },
        { name: names[1], description: description }
      ])
    }
  end
end
