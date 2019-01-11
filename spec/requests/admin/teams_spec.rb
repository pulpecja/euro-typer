require 'rails_helper'

RSpec.describe 'Teams', type: :request do
  let!(:user_admin) { create(:user, :admin) }
  let!(:user_registered) { create(:user, :registered) }
  let(:model) { Team }
  let!(:teams) { create_list(:team, 2) }
  let(:team) { teams.first }
  let(:type) { model.to_s.pluralize.underscore.dasherize }
  let(:photo_data) { Base64.encode64(file_fixture("flag_pl.png").read) }
  let(:photo) do
     "data:image/png;base64," + photo_data
  end

  let(:params) do
    {
      data: {
        type: type,
        attributes: attributes,
        relationships: {}
      }
    }
  end

  include_context 'unauthorised_requests'

  context 'admin namespace' do
    context 'registered user logged in' do
      before do
        logged_in_response = login(user_registered)
        @auth_headers = get_auth_headers(logged_in_response)
      end

      describe 'GET /teams' do
        let(:index_request) do
          get '/admin/teams',
              headers: @auth_headers
        end

        it 'returns all instances' do
          index_request
          expect(response).to have_http_status(200)
          expect(json_data.size).to eq model.all.count
        end
      end

      describe 'GET /team/:id' do
        context 'with valid id' do
          let(:show_request) do
            get "/admin/teams/#{team.id}",
                headers: @auth_headers
          end

          it 'returns team with id provided' do
            show_request
            expect(response).to have_http_status(200)
            expect(json_data['id']).to eq(team.id.to_s)
          end
        end

        context 'with invalid id' do
          let(:show_request) do
            get "/admin/teams/0",
                headers: @auth_headers
          end

          it 'returns team with id provided' do
            show_request
            expect(response).to have_http_status(404)
            expect(json).to eq({ "message"=>"not_found" })
          end
        end
      end

      describe 'POST /teams' do
        context 'valid data' do
          let(:attributes) do
            {
              'name': 'Nowy zespol',
              'name_en': 'New team'
            }
          end

          let(:post_request) do
            post '/admin/teams',
                 params: params,
                 headers: @auth_headers
          end

          it 'creates new team' do
            expect { post_request }.to change { Team.count }.by(0)
            expect(response).to have_http_status(403)
            expect(json).to eq "message" => "You are not authorized to access this page."
          end
        end

        context 'invalid data' do
          let(:attributes) do
            {
              'name': '',
              'name_en': ''
            }
          end

          let(:post_request) do
            post '/admin/teams',
                 params: params,
                 headers: @auth_headers
          end

          it 'does not create new team' do
            expect { post_request }.to change { Team.count }.by(0)
            expect(response).to have_http_status(403)
            expect(json).to eq "message" => "You are not authorized to access this page."
          end
        end

      end

      describe 'PATCH /team/:id' do
        context 'with valid data' do
          let(:attributes)  do
            { "name": "New name" }
          end

          let(:patch_request) do
            patch "/admin/teams/#{team.id}",
                  params: params,
                  headers: @auth_headers
          end

          it 'updates team' do
            patch_request
            expect(response).to have_http_status(403)
            expect(json).to eq "message" => "You are not authorized to access this page."

          end
        end

        context 'with invalid data' do
          let(:attributes) do
            {
              "name": '',
              "name_en": ''
            }
          end

          let(:patch_request) do
            patch "/admin/teams/#{team.id}",
                  params: params,
                  headers: @auth_headers
          end

          it 'updates team' do
            patch_request
            expect(response).to have_http_status(403)
            expect(json).to eq "message" => "You are not authorized to access this page."
          end
        end
      end

      describe 'DELETE /team/:id' do
        let(:valid_params) do
          {
            id: team.id
          }
        end

        let(:delete_request) do
          delete "/admin/teams/#{team.id}",
                 params: valid_params,
                 headers: @auth_headers
        end

        it 'removes team' do
          expect { delete_request }.to change { Team.count }.by(0)
          expect(response).to have_http_status(403)
          expect(json).to eq "message" => "You are not authorized to access this page."
        end
      end
    end

    context 'admin logged in' do
      before do
        logged_in_response = login(user_admin)
        @auth_headers = get_auth_headers(logged_in_response)
      end

      describe 'GET /teams' do
        let(:index_request) do
          get '/admin/teams',
              headers: @auth_headers
        end

        it 'returns all instances' do
          index_request
          expect(response).to have_http_status(200)
          expect(json_data.size).to eq model.all.count
        end
      end

      describe 'GET /team/:id' do
        context 'with valid id' do
          let(:show_request) do
            get "/admin/teams/#{team.id}",
                headers: @auth_headers
          end

          it 'returns team with id provided' do
            show_request
            expect(response).to have_http_status(200)
            expect(json_data['id']).to eq(team.id.to_s)
          end
        end

        context 'with invalid id' do
          let(:show_request) do
            get "/admin/teams/0",
                headers: @auth_headers
          end

          it 'returns team with id provided' do
            show_request
            expect(response).to have_http_status(404)
            expect(json).to eq({ "message"=>"not_found" })
          end
        end
      end

      describe 'POST /teams' do
        context 'valid data' do
          let(:attributes) do
            {
              'name': 'Nowy zespol',
              'name_en': 'New team',
              'photo': photo
            }
          end

          let(:post_request) do
            post '/admin/teams',
                 params: params,
                 headers: @auth_headers
          end

          it 'creates new team' do
            photo_sizes = ["url", "mini", "thumb", "medium"]
            expect { post_request }.to change { Team.count }.by(1)
            expect(response).to have_http_status(200)
            expect(json_attributes['name']).to eq('Nowy zespol')
            expect(json_attributes['photo']['url']).to eq(photo_sizes)
          end
        end

        context 'invalid data' do
          let(:attributes) do
            {
              'name': '',
              'name_en': ''
            }
          end

          let(:post_request) do
            post '/admin/teams',
                 params: params,
                 headers: @auth_headers
          end

          it 'does not create new team' do
            expect { post_request }.to change { Team.count }.by(0)
            expect(response).to have_http_status(422)
            expect(json).to eq({ "message"=>"unprocessable_entity" })
          end
        end

      end

      describe 'PATCH /team/:id' do
        context 'with valid data' do
          let(:attributes)  do
            { "name": "New name" }
          end

          let(:patch_request) do
            patch "/admin/teams/#{team.id}",
                  params: params,
                  headers: @auth_headers
          end

          it 'updates team' do
            patch_request
            expect(response).to have_http_status(200)
            expect(json_attributes['name']).to eq('New name')
          end
        end

        context 'with invalid data' do
          let(:attributes) do
            {
              "name": '',
              "name_en": ''
            }
          end

          let(:patch_request) do
            patch "/admin/teams/#{team.id}",
                  params: params,
                  headers: @auth_headers
          end

          it 'updates team' do
            patch_request
            expect(response).to have_http_status(422)
            expect(json).to eq({ "message"=>"unprocessable_entity" })
          end
        end
      end

      describe 'DELETE /team/:id' do
        let(:valid_params) do
          {
            id: team.id
          }
        end

        let(:delete_request) do
          delete "/admin/teams/#{team.id}",
                 params: valid_params,
                 headers: @auth_headers
        end

        it 'removes team' do
          expect { delete_request }.to change { Team.count }.by(-1)
          expect(response).to have_http_status(204)
        end
      end
    end
  end
end
