RSpec.describe OpenAPI::DSL::Proxy::Schema do
  let(:schema) { described_class }

  describe 'data types' do
    describe 'string' do
      specify {
        expect(schema.string.serialize).to eq({
          type: 'string'
        })
      }

      specify {
        expect(schema.string { description 'First name' }.serialize).to eq({
          type: 'string',
          description: 'First name'
        })
      }
    end

    describe 'integer' do
      specify {
        expect(schema.integer.serialize).to eq({
          type: 'integer',
          format: 'int32'
        })
      }

      specify {
        expect(schema.integer { default 1 }.serialize).to eq({
          type: 'integer',
          format: 'int32',
          default: 1
        })
      }
    end

    describe 'long' do
      specify {
        expect(schema.long.serialize).to eq({
          type: 'integer',
          format: 'int64'
        })
      }

      specify {
        expect(schema.long { default 1 }.serialize).to eq({
          type: 'integer',
          format: 'int64',
          default: 1
        })
      }
    end

    describe 'float' do
      specify {
        expect(schema.float { default 1.0 }.serialize).to eq({
          type: 'number',
          format: 'float',
          default: 1.0
        })
      }
    end

    describe 'double' do
      specify {
        expect(schema.double { default 1.0 }.serialize).to eq({
          type: 'number',
          format: 'double',
          default: 1.0
        })
      }
    end

    describe 'byte' do
      specify {
        expect(schema.byte.serialize).to eq({
          type: 'string',
          format: 'byte'
        })
      }
    end

    describe 'binary' do
      specify {
        expect(schema.binary.serialize).to eq({
          type: 'string',
          format: 'binary'
        })
      }
    end

    describe 'boolean' do
      specify {
        expect(schema.boolean.serialize).to eq({
          type: 'boolean'
        })
      }
    end

    describe 'date' do
      specify {
        expect(schema.date.serialize).to eq({
          type: 'string',
          format: 'date'
        })
      }
    end

    describe 'datetime' do
      specify {
        expect(schema.datetime.serialize).to eq({
          type: 'string',
          format: 'date-time'
        })
      }
    end

    describe 'password' do
      specify {
        expect(schema.password.serialize).to eq({
          type: 'string',
          format: 'password'
        })
      }
    end

    describe 'object' do
      specify {
        person = schema.object do
          property :name, string
          property :age, integer
        end

        expect(person.serialize).to eq({
          type: 'object',
          properties: {
            name: {
              type: 'string'
            },
            age: {
              type: 'integer',
              format: 'int32'
            }
          }
        })
      }
    end

    describe 'array' do
      context 'of primitive' do
        specify {
          names = schema.array(of: schema.string { description 'First name.' }) do
            description 'An array of first names.'
          end

          expect(names.serialize).to eq({
            type: 'array',
            description: 'An array of first names.',
            items: {
              type: 'string',
              description: 'First name.'
            }
          })
        }
      end

      context 'of object' do
        specify {
          person = schema.object do
            property :firstName, string
            property :lastName, string
          end

          people = schema.array(of: person) do
            title 'People'
            description 'An array of people.'
          end

          expect(people.serialize).to eq({
            type: 'array',
            title: 'People',
            description: 'An array of people.',
            items: {
              type: 'object',
              properties: {
                firstName: {
                  type: 'string'
                },
                lastName: {
                  type: 'string'
                }
              }
            }
          })
        }
      end

      context 'of array' do
        specify {
          columns = schema.array(of: schema.boolean) { title 'Columns' }
          grid = schema.array(of: columns) { title 'Grid' }

          expect(grid.serialize).to eq({
            type: 'array',
            title: 'Grid',
            items: {
              type: 'array',
              title: 'Columns',
              items: {
                type: 'boolean'
              }
            }
          })
        }
      end
    end
  end

  describe 'schema object properties' do
    describe 'type' do
      specify {
        expect(schema.define { type 'string' }.serialize).to eq({
          type: 'string'
        })
      }
    end

    describe 'format' do
      specify {
        expect(schema.define { format 'email' }.serialize).to eq({
          format: 'email'
        })
      }
    end

    describe 'enum' do
      specify {
        expect(schema.define { enum 'north', 'south', 'east', 'west' }.serialize).to eq({
          enum: [
            'north',
            'south',
            'east',
            'west'
          ]
        })
      }

      specify {
        expect(schema.define { enum %w(north south east west) }.serialize).to eq({
          enum: [
            'north',
            'south',
            'east',
            'west'
          ]
        })
      }
    end

    describe 'title' do
      specify {
        expect(schema.define { title 'A title' }.serialize).to eq({
          title: 'A title'
        })
      }
    end

    describe 'description' do
      specify {
        expect(schema.define { description 'A description' }.serialize).to eq({
          description: 'A description'
        })
      }
    end

    describe 'required' do
      specify {
        expect(schema.define { required 'id', 'email' }.serialize).to eq({
          required: [
            'id',
            'email'
          ]
        })
      }

      specify {
        expect(schema.define { required %w(id email) }.serialize).to eq({
          required: [
            'id',
            'email'
          ]
        })
      }
    end

    describe 'default' do
      specify {
        expect(schema.define { default :any }.serialize).to eq({
          default: :any
        })
      }
    end

    describe 'all_of' do
      let(:name_mixin) {
        schema.object do
          property :firstName, string
          property :lastName, string
        end
      }

      let(:age_mixin) {
        schema.object do
          property :age, integer
        end
      }

      let(:person) {
        schema.define do |s|
          s.all_of name_mixin, age_mixin
        end
        # or consider a shortened version
        # schema.all_of name_mixin, age_mixin
        #
        # How about giving it a better name? Like:
        #
        # - schema.product ...
        # - schema.product_type ...
      }

      specify {
        expect(person.serialize).to eq({
          allOf: [
            name_mixin.serialize,
            age_mixin.serialize
          ]
        })
      }
    end

    describe 'one_of' do
      let(:string) { schema.string }
      let(:integer) { schema.integer }

      let(:string_or_integer) {
        schema.define do |s|
          s.one_of string, integer
        end
        # or consider a shortened version
        # schema.one_of string, integer
        #
        # How about giving it a better name? Like:
        #
        # - schema.union ...
        # - schema.union_type ...
      }

      specify {
        expect(string_or_integer.serialize).to eq({
          oneOf: [
            string.serialize,
            integer.serialize
          ]
        })
      }
    end

    describe 'properties' do
      specify {
        user = schema.define do
          properties \
            name: string,
            admin: boolean
        end

        expect(user.serialize).to eq({
          properties: {
            name: {
              type: 'string'
            },
            admin: {
              type: 'boolean'
            }
          }
        })
      }
    end

    describe 'items' do
      specify {
        strings = schema.define do
          items string
        end

        expect(strings.serialize).to eq({
          items: {
            type: 'string'
          }
        })
      }
    end
  end

  describe 'examples' do
    describe 'relationship links' do
      let(:expected) {
        {
          type: 'object',
          properties: {
            links: {
              type: 'object',
              properties: {
                self: {
                  type: 'string',
                  description: 'A link to this resource.'
                },
                related: {
                  type: 'string',
                  description: 'A link to the related resource(s).'
                }
              }
            }
          }
        }
      }

      context 'without shortcuts' do
        let(:relationship_links) {
          schema.define do
            type 'object'
            properties \
              links: schema {
                type 'object'
                properties \
                  self: string { description 'A link to this resource.' },
                  related: string { description 'A link to the related resource(s).' }
              }
          end
        }

        specify { expect(relationship_links.serialize).to eq(expected) }
      end

      context 'with shortcuts' do
        let(:relationship_links) {
          schema.object do
            property :links, object {
              property :self, string { description 'A link to this resource.' }
              property :related, string { description 'A link to the related resource(s).' }
            }
          end
        }

        specify { expect(relationship_links.serialize).to eq(expected) }
      end
    end

    describe 'resource ID' do
      specify {
        resource_id = schema.object do
          property :id, string
          property :type, string
        end

        expect(resource_id.serialize).to eq({
          type: 'object',
          properties: {
            id: {
              type: 'string'
            },
            type: {
              type: 'string'
            }
          }
        })
      }
    end

    describe 'resource links' do
      specify {
        resource_links = schema.object do
          property :links, object {
            property :self, string { description 'A link to this resource.' }
          }
        end

        expect(resource_links.serialize).to eq({
          type: 'object',
          properties: {
            links: {
              type: 'object',
              properties: {
                self: {
                  type: 'string',
                  description: 'A link to this resource.'
                }
              }
            }
          }
        })
      }
    end

    describe 'errors' do
      let(:error) {
        schema.object do
          properties \
            id: string { description 'A unique identifier for this particular occurrence of the problem.' },
            status: string { description 'The HTTP status code applicable to this problem, expressed as a string value.' },
            code: string { description 'An application-specific error code, expressed as a string value.' },
            title: string { description 'A short, human-readable summary of the problem.' },
            detail: string { description 'A human-readable explanation specific to this occurrence of the problem.' },
            source: string { description 'An object containing references to the source of the error.' },
            meta: string { description 'A meta object containing non-standard meta-information about the error.' }
        end
      }

      describe 'errors' do
        specify {
          # See http://djellemah.com/blog/2013/10/09/instance-eval-with-access-to-outside-scope/ for a way around this limitation.
          errors = schema.object do |s|
            s.property :errors, s.array(of: error)
          end

          expect(errors.serialize).to eq({
            type: 'object',
            properties: {
              errors: {
                type: 'array',
                items: error.serialize
              }
            }
          })
        }
      end
    end

    describe 'customer' do
      let(:resource_id) {
        schema.object do
          property :id, string
          property :type, string
        end
      }

      let(:customer_resource_id) {
        schema.define do |s|
          customer = s.object {
            property :type, string { enum 'customer' }
          }

          s.all_of resource_id, customer
        end
      }

      let(:customer_attributes) {
        schema.object do
          property :attributes, object {
            properties firstName: string, lastName: string
          }
        end
      }

      let(:customer) {
        schema.define do |s|
          s.title 'Customer'
          s.all_of customer_resource_id, customer_attributes
        end
      }

      specify {
        expect(customer.serialize).to eq({
          title: 'Customer',
          allOf: [
            customer_resource_id.serialize,
            customer_attributes.serialize
          ]
        })
      }
    end
  end
end
