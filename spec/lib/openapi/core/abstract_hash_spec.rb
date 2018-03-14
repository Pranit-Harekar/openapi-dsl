RSpec.describe OpenAPI::Core::AbstractHash do
  module Test
    class Option
      def initialize(opts = {})
        @value = opts[:value]
      end

      def serialize
        {}.tap do |h|
          h[:value] = @value if @value.present?
        end
      end
    end

    class Options < OpenAPI::Core::AbstractHash
    end
  end

  subject { Test::Options.new }
  let(:value_class) { Test::Option }

  describe 'initial state' do
    it 'is empty' do
      expect(subject).to be_empty
    end
  end

  describe '#serialize' do
    context 'when empty' do
      specify {
        expect(subject.serialize).to be_empty
      }
    end

    context 'when non-empty' do
      specify {
        subject.add('color', value: 'red')
        subject.add('toggle', value: 'on')

        expect(subject.serialize).to eq({
          'color' => { value: 'red' },
          'toggle' => { value: 'on' }
        })
      }
    end
  end
end
