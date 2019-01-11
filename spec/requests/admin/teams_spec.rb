require 'rails_helper'

RSpec.describe 'Teams', type: :request do
  let!(:user) { create(:user, :admin) }
  let(:model) { Team }
  let!(:teams) { create_list(:team, 2) }
  let(:team) { teams.first }
  let(:type) { model.to_s.pluralize.underscore.dasherize }

  context 'admin namespace' do
    before do
      logged_in_response = login(user)
      @auth_headers = get_auth_headers(logged_in_response)
    end

    describe 'GET /teams' do
      let(:index_request) do
        get '/admin/teams',
            params: {},
            headers: @auth_headers
      end

      it 'returns all instances' do
        index_request
        expect(response).to have_http_status(200)
        expect(json_data.size).to eq model.all.count
      end
    end

    describe 'GET /team/:id' do
      let(:show_request) do
        get "/admin/teams/#{team.id}",
            params: {},
            headers: @auth_headers
      end

      it 'returns team with id provided' do
        show_request
        expect(response).to have_http_status(200)
        expect(json_data['id']).to eq(team.id.to_s)
      end
    end

    describe 'POST /teams' do
      let(:valid_data) do
        {
          data: {
            type: 'Team',
            attributes: {
              name: "Nowy zespol",
              name_en: "New team"
            },
            relationships: {}
          }
        }
      end

      let(:post_request) do
        post '/admin/teams',
             params: valid_data,
             headers: @auth_headers
      end

      it 'creates new team' do
        expect { post_request }.to change { Team.count }.by(1)
        expect(response).to have_http_status(200)
        expect(json_attributes['name']).to eq('Nowy zespol')
      end
    end

    describe 'PATCH /team/:id' do
      let(:valid_data) do
        {
          id: team.id,
          data: {
            type: type,
            id: team.id,
            attributes: {
              "name": "New name"
            },
            relationships: {}
          }
        }
      end

      let(:patch_request) do
        patch "/admin/teams/#{team.id}",
             params: valid_data,
             headers: @auth_headers
      end

      it 'updates team' do
        patch_request
        expect(response).to have_http_status(200)
        expect(json_attributes['name']).to eq('New name')
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
