RSpec.describe OpenAPI::Core::Schema do
  describe 'examples' do
    describe 'collection links' do
      let(:self_) {
        described_class.new(type: 'string', description: 'A link to this resource.')
      }

      let(:first) {
        described_class.new(type: 'string', description: 'The first page of data.')
      }

      let(:last) {
        described_class.new(type: 'string', description: 'The last page of data.')
      }

      let(:prev) {
        described_class.new(type: 'string', description: 'The previous page of data.')
      }

      let(:next_type) { 'string' }
      let(:next_description) { 'The next page of data.' }

      let(:links) {
        described_class.new(type: 'object').tap do |s|
          s.properties['self'] = self_
          s.properties['first'] = first
          s.properties['last'] = last
          s.properties['prev'] = prev
          s.properties.add('next', type: next_type, description: next_description)
        end
      }

      let(:collection_links) {
        described_class.new(type: 'object').tap do |s|
          s.properties['links'] = links
        end
      }

      specify {
        expect(collection_links.serialize).to eq({
          type: 'object',
          properties: {
            'links' => {
              type: 'object',
              properties: {
                'self' => {
                  type: self_.type,
                  description: self_.description
                },
                'first' => {
                  type: first.type,
                  description: first.description
                },
                'last' => {
                  type: last.type,
                  description: last.description
                },
                'prev' => {
                  type: prev.type,
                  description: prev.description
                },
                'next' => {
                  type: next_type,
                  description: next_description
                }
              }
            }
          }
        })
      }
    end
  end
end
