require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  let!(:users) { create_list(:user, 2, :registered) }
  let!(:user_admin) { create(:user, :admin) }
  let(:user_registered) { users.first }

  let(:instance) { users.first }
  let(:model) { User }
  let(:model_string) { model.to_s }
  let(:photo) do
    "data:image/png;base64," + photo_data
  end
  let(:photo_data) { Base64.encode64(file_fixture("flag_pl.png").read) }
  let(:type) { model.to_s.pluralize.underscore.dasherize }

  let(:params) do
    {
      data: {
        type: type,
        attributes: attributes,
        relationships: {}
      }
    }
  end

  context 'admin namespace' do
    context 'not logged in' do
      let(:auth_headers) { {} }
      include_examples 'unauthorized_requests'
    end

    context 'registered user logged in' do
      before do
        @logged_in_response = login(user_registered)
      end

      let(:auth_headers) { get_auth_headers(@logged_in_response) }

      include_examples 'unauthorized_requests'
    end

    context 'user admin logged in' do
      before do
        logged_in_response = login(user_admin)
        @auth_headers = get_auth_headers(logged_in_response)
      end

      describe "GET /admin/users" do
        let(:index_request) do
          get '/admin/users',
              headers: @auth_headers
        end

        it "returns list of the users" do
          index_request
          expect(response).to have_http_status(200)
          expect(response.content_type).to eq("application/json")
          expect(json_data.size).to eq model.all.count
        end

        describe 'filters' do
          let(:index_request) do
            get '/admin/users',
                params: {
                  filter: {
                    deleted_users: true
                  }
                },
                headers: @auth_headers
          end

          it "returns list of deleted users" do
            index_request
            expect(response).to have_http_status(200)
            expect(response.content_type).to eq("application/json")
            expect(json_data.size).to eq model.deleted.count
          end
        end
      end

      describe "GET /admin/user/:id" do
        context 'with valid id' do
          let(:show_request) do
            get "/admin/users/#{user_registered.id}",
                headers: @auth_headers
          end

          it 'returns user with id provided' do
            show_request
            expect(response).to have_http_status(200)
            expect(response.content_type).to eq("application/json")
            expect(json_data['id']).to eq(user_registered.id.to_s)
          end
        end

        context 'with invalid id' do
          let(:show_request) do
            get "/admin/users/0",
                headers: @auth_headers
          end

          it 'does not return user with wrong id provided' do
            show_request
            expect(response).to have_http_status(404)
            expect(json).to eq "message" => "Couldn't find #{model_string} with 'id'=0"
          end
        end
      end

      describe "POST /admin/users" do
        let(:post_request) do
          post '/admin/users',
               params: params,
               headers: @auth_headers
        end

        context 'valid data' do
          let(:attributes) do
            {
              'email': 'newuser@email.com',
              'password': 'password',
              'username': 'Username',
              'photo': photo
            }
          end

          it 'creates new user' do
            expect { post_request }.to change { User.count }.by(1)
            expect(response).to have_http_status(200)
            expect(json_attributes['username']).to eq('Username')
            expect(json_attributes['photo']['url']).to be
          end
        end

        context 'invalid data' do
          let(:attributes) do
            {
              'email': '',
              'password': '',
              'username': ''
            }
          end

          it 'does not create new user' do
            expect { post_request }.to change { User.count }.by(0)
            expect(response).to have_http_status(422)
            expect(json).to eq(
              {"message"=>"Negatywne sprawdzenie poprawności: Password nie może być puste, Email nie może być puste, Nazwa użytkownika nie może być puste"}
            )
          end
        end
      end

      describe "PATCH /admin/user/:id" do
        let(:patch_request) do
          patch "/admin/users/#{user_registered.id}",
                params: params,
                headers: @auth_headers
        end

        context 'with valid data' do
          let(:attributes)  do
            {
              "username": "New username"
            }
          end

          it "updates user" do
            patch_request
            expect(response).to have_http_status(200)
            expect(json_attributes['username']).to eq('New username')
          end
        end

        context 'with invalid data' do
          let(:attributes) do
            {
              "username": ''
            }
          end

          it 'does not update user' do
            patch_request
            expect(response).to have_http_status(422)
            expect(json).to eq(
              { "message" => "Negatywne sprawdzenie poprawności: Nazwa użytkownika nie może być puste" }
            )
          end
        end
      end

      describe "DELETE /admin/user/:id" do
        context 'with valid params' do
          let(:delete_request) do
            delete "/admin/users/#{user_registered.id}",
                   headers: @auth_headers
          end

          it "removes user" do
            expect { delete_request }.to change { User.count }.by(-1)
            expect(response).to have_http_status(204)
          end
        end

        context 'with invalid params' do
          let(:delete_request) do
            delete "/admin/users/0",
                   headers: @auth_headers
          end

          it "does not remove user" do
            expect { delete_request }.to change { User.count }.by(0)
            expect(response).to have_http_status(404)
            expect(json).to eq({"message"=>"Couldn't find #{model_string} with 'id'=0"})
          end
        end
      end
    end
  end
end
