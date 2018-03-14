RSpec.describe OpenAPI::Core::ServerVariables do
  describe '#serialize' do
    specify {
      names = [ Faker::Lorem.word, Faker::Lorem.word ]
      defaults = [ Faker::Lorem.word, Faker::Lorem.word ]
      description = Faker::Lorem.sentence

      subject.add(names[0], default: defaults[0])
      subject.add(names[1], default: defaults[1], description: description)

      expect(subject.serialize).to eq({
        names[0] => { default: defaults[0] },
        names[1] => { default: defaults[1], description: description }
      })
    }
  end
end
