require_relative '../lib/openapi'

bookmarker = OpenAPI.define do
  title 'Bookmarker'
  version '1.0.0'

  server 'https://api.bookmarker.com'

  tag 'Users'
  tag 'Sessions'
  tag 'Bookmarks'
  tag 'Sites'
  tag 'Tasks'

  paths do
    post '/users' do
      tag 'Users'
      description 'Create a new user.'

      data do
        type 'user'

        prop :email
        prop :password, format: :password
        prop :password_confirmation, format: :password
        prop :display_name, required: false
      end

      responses do
        status 201 do
          description 'Successfully created the new user.'

          header 'Location', description: 'The URL of the newly created resource.'

          data do
            type 'user'

            prop :display_name
            prop :email
          end

          meta do
            prop :token, description: 'A JWT.'
          end
        end

        status 400, errors: true do
          description 'Bad request.'
        end
      end
    end
  end
end

print bookmarker.to_yaml
