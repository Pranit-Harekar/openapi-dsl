RSpec.describe OpenAPI::Core::AbstractArray do
  module Test
    class Tag
      def initialize(opts = {})
        @name = opts[:name]
      end

      def serialize
        {}.tap do |h|
          h[:name] = @name if @name.present?
        end
      end
    end

    class Tags < OpenAPI::Core::AbstractArray
    end
  end

  subject { Test::Tags.new }
  let(:element_class) { Test::Tag }

  describe 'initial state' do
    it 'is empty' do
      expect(subject).to be_empty
    end
  end

  describe '#serialize' do
    context 'when empty' do
      context 'with default serialize_empty' do
        specify {
          expect(subject.serialize).to be_empty
        }
      end

      context 'with custom serialize_empty' do
        before do
          def subject.serialize_empty
            [ element_class.new(name: 'John').serialize ]
          end
        end

        specify {
          expect(subject.serialize).to eq([
            { name: 'John' }
          ])
        }
      end
    end

    context 'when non-empty' do
      specify {
        subject.add(name: 'Adam')
        subject.add(name: 'Eve')

        expect(subject.serialize).to eq([
          { name: 'Adam' },
          { name: 'Eve' }
        ])
      }
    end
  end
end
