require 'rails_helper'

RSpec.describe "WinnerTypes", winner_type: :request do
  let!(:competition) { create(:competition) }
  let(:instance) { create(:winner_type) }
  let(:model) { WinnerType }
  let(:model_string) { model.to_s }
  let(:match) { create(:match) }
  let(:team) { create(:team) }
  let(:users) { create_list(:user, 3) }
  let!(:user_registered) { create(:user, :registered) }
  let!(:winner_type) do
    create(
      :winner_type,
      competition: competition,
      team: team,
      user: user_registered
    )
  end
  let!(:winner_type_other_user) { create(:winner_type, user: users.first) }
  let(:type) { model.to_s.pluralize.underscore.underscore }

  let(:params) do
    {
      data: {
        winner_type: winner_type,
        attributes: attributes
      }
    }
  end

  context 'not logged in' do
    let(:auth_headers) { {} }
    include_examples 'not_logged_in_requests'
  end

  context 'registered winner_type logged in' do
    before do
      logged_in_response = login(user_registered)
      @auth_headers = get_auth_headers(logged_in_response)
      create(:setting, :end_of_voting)
    end

    describe 'GET /winner_types' do
      let(:index_request) do
        get '/winner_types',
            params: {
              filter: {
                competition_id: competition.id.to_s
              }
            },
            headers: @auth_headers
      end

      it 'returns all instances for sent competition id' do
        index_request
        expect(response).to have_http_status(200)
        expect(json_data.size).to eq model.all.by_competition(competition.id).size
      end
    end

    describe 'GET /winner_type/:id' do
      context 'with valid id' do
        let(:show_request) do
          get "/winner_types/#{winner_type.id}",
              headers: @auth_headers
        end

        it 'returns winner_type with id provided' do
          show_request
          expect(response).to have_http_status(200)
          expect(json_data['id']).to eq(winner_type.id.to_s)
        end
      end

      context 'with invalid id' do
        let(:show_request) do
          get "/winner_types/0",
              headers: @auth_headers
        end

        it 'returns winner_type with id provided' do
          show_request
          expect(response).to have_http_status(404)
          expect(json).to eq "message" => "Couldn't find #{model} with 'id'=0"
        end
      end
    end

    describe 'POST /winner_types' do
      let(:post_request) do
        post '/winner_types',
             params: params,
             headers: @auth_headers
      end

      context 'valid data' do
        let(:attributes) do
          {
            'competition_id': competition.id.to_s,
            'team_id': team.id.to_s,
            'user_id': user_registered.id.to_s
          }
        end

        it 'creates new winner_type' do
          expect { post_request }.to change { WinnerType.count }.by(1)
          expect(response).to have_http_status(200)
          expect(json_relationships['competition']['data']['id']).to eq(competition.id.to_s)
          expect(json_relationships['team']['data']['id']).to eq(team.id.to_s)
          expect(json_relationships['user']['data']['id']).to eq(user_registered.id.to_s)
        end
      end

      context 'invalid data' do
        let(:attributes) do
          {
            'competition_id': '',
            'team_id': '',
            'user_id': ''
          }
        end

        it 'does not create new winner_type' do
          expect { post_request }.to change { WinnerType.count }.by(0)
          expect(response).to have_http_status(422)
          expect(json).to eq(
            'message' => 'Negatywne sprawdzenie poprawności: Competition nie może być puste, Competition nie może być puste, User nie może być puste, User nie może być puste, Team nie może być puste, Team nie może być puste'
          )
        end
      end
    end

    describe 'PATCH /winner_types/:id' do
      let(:patch_request) do
        patch "/winner_types/#{winner_type.id}",
              params: params,
              headers: @auth_headers
      end

      let(:patch_request_other_user) do
        patch "/winner_types/#{winner_type_other_user.id}",
              params: params,
              headers: @auth_headers
      end

      context 'with valid data' do
        let(:other_team) { create(:team) }
        let(:attributes) do
          {
            'team_id': other_team.id.to_s
          }
        end

        it 'updates winner_type' do
          patch_request
          expect(response).to have_http_status(200)
          expect(json_relationships['team']['data']['id']).to eq(other_team.id.to_s)
         end

        it 'does not update winner_type of other user' do
          patch_request_other_user
          expect(response).to have_http_status(403)
        end
      end

      context 'with invalid data' do
        let(:attributes) do
          {
            'team_id': ''
          }
        end

        it 'does update winner_type' do
          patch_request
          expect(response).to have_http_status(422)
          expect(json).to eq(
            'message' => 'Negatywne sprawdzenie poprawności: Team nie może być puste, Team nie może być puste'
          )
        end

        it 'does not update winner_type of other user' do
          patch_request_other_user
          expect(response).to have_http_status(403)
        end
      end
    end

    describe 'DELETE /winner_type/:id' do
      context 'valid params' do
        let(:delete_request) do
          delete "/winner_types/#{winner_type.id}",
                headers: @auth_headers
        end

        let(:delete_request_other_user) do
          delete "/winner_types/#{winner_type_other_user.id}",
                headers: @auth_headers
        end

        it 'removes winner_type if user is user' do
          expect { delete_request }.to change { WinnerType.count }.by(-1)
          expect(response).to have_http_status(204)
        end

        it 'does not remove winner_type of other user' do
          expect { delete_request_other_user }.to change { WinnerType.count }.by(0)
          expect(response).to have_http_status(403)
        end
      end

      context 'invalid params' do
        let(:delete_request) do
          delete "/winner_types/0",
                headers: @auth_headers
        end

        it 'does not remove winner_type' do
          expect { delete_request }.to change { WinnerType.count }.by(0)
          expect(response).to have_http_status(404)
          expect(json).to eq({"message"=>"Couldn't find #{model_string} with 'id'=0"})
        end
      end
    end
  end
end
