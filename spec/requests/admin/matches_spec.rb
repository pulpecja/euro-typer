require 'rails_helper'

RSpec.describe "Admin::Matches", type: :request do
  let(:instance) { matches.first }
  let(:match) { matches.first }
  let(:matches) { create_list(:match, 3)}
  let(:model) { Match }
  let(:model_string) { model.to_s }
  let!(:matches) { create_list(:match, 2) }
  let(:match) { matches.first }
  let(:round) { create(:round)}
  let(:team_1) { create(:team)}
  let(:team_2) { create(:team)}
  let(:type) { model.to_s.pluralize.underscore.dasherize }
  let!(:user_admin) { create(:user, :admin) }
  let!(:user_registered) { create(:user, :registered) }

  let(:params) do
    {
      data: {
        type: type,
        attributes: attributes
      }
    }
  end

  context 'admin namespace' do
    context 'not logged in' do
      let(:auth_headers) { {} }
      include_examples 'admin_namespace_not_logged_in_requests'
    end

    context 'registered user logged in' do
      before do
        @logged_in_response = login(user_registered)
      end

      let(:auth_headers) { get_auth_headers(@logged_in_response) }

      include_examples 'admin_namespace_unauthorized_requests'
    end

    context 'admin logged in' do
      before do
        logged_in_response = login(user_admin)
        @auth_headers = get_auth_headers(logged_in_response)
      end

      describe 'GET /admin/matches' do
        let(:index_request) do
          get '/admin/matches',
              headers: @auth_headers
        end

        it 'returns all instances' do
          index_request
          expect(response).to have_http_status(200)
          expect(json_data.size).to eq model.all.count
        end
      end

      describe 'GET /admin/matches/:id' do
        context 'with valid id' do
          let(:show_request) do
            get "/admin/matches/#{match.id}",
                headers: @auth_headers
          end

          it 'returns match with id provided' do
            show_request
            expect(response).to have_http_status(200)
            expect(json_data['id']).to eq(match.id.to_s)
          end
        end

        context 'with invalid id' do
          let(:show_request) do
            get "/admin/matches/0",
                headers: @auth_headers
          end

          it 'returns match with id provided' do
            show_request
            expect(response).to have_http_status(404)
            expect(json).to eq "message" => "Couldn't find #{model} with 'id'=0"
          end
        end
      end

      describe 'POST /admin/matches' do
        let(:post_request) do
          post '/admin/matches',
               params: params,
               headers: @auth_headers
        end

        context 'valid data' do
          let(:played) { Time.now.strftime("%FT%T") }
          let(:attributes) do
            {
              'first_team_id': team_1.id.to_s,
              'second_team_id': team_2.id.to_s,
              'round_id': round.id.to_s,
              'played': played
            }
          end

          it 'creates new match' do
            expect { post_request }.to change { Match.count }.by(1)
            expect(response).to have_http_status(200)
            expect(json_attributes['played']).to eq(played)
            expect(json_relationships['first_team']['data']['id']).to eq(team_1.id.to_s)
            expect(json_relationships['second_team']['data']['id']).to eq(team_2.id.to_s)
            expect(json_relationships['round']['data']['id']).to eq(round.id.to_s)
          end
        end

        context 'invalid data' do
          let(:attributes) do
            {
              'first_team_id': '',
              'second_team_id': '',
              'round': '',
              'played': ''
            }
          end

          it 'does not create new match' do
            expect { post_request }.to change { Match.count }.by(0)
            expect(response).to have_http_status(422)
            expect(json).to eq(
              { 
                "message" => "Negatywne sprawdzenie poprawności: First team nie może być puste, Second team nie może być puste, Round nie może być puste, Termin nie może być puste, Kolejka nie może być puste, Add You can't choose the same teams"
                }
            )
          end
        end
      end

      describe 'PATCH /admin/matches/:id' do
        let(:patch_request) do
          patch "/admin/matches/#{match.id}",
                params: params,
                headers: @auth_headers
        end

        context 'with valid data' do
          let(:new_played) { (Time.now + 1.day).strftime("%FT%T") }
          let(:new_match) { create(:match) }
          let(:attributes) do
            {
              'first_team_id': team_2.id.to_s,
              'second_team_id': team_1.id.to_s,
              'round_id': round.id.to_s,
              'played': new_played
            }
          end

          it 'updates match' do
            patch_request
            expect(response).to have_http_status(200)
            expect(json_attributes['played']).to eq(new_played)
            expect(json_relationships['first_team']['data']['id']).to eq(team_2.id.to_s)
            expect(json_relationships['second_team']['data']['id']).to eq(team_1.id.to_s)
            expect(json_relationships['round']['data']['id']).to eq(round.id.to_s)
           end
        end

        context 'with invalid data' do
          let(:attributes) do
            {
              "played": ''
            }
          end

          it 'does not update match' do
            patch_request
            expect(response).to have_http_status(422)
            expect(json).to eq(
              { "message" => "Negatywne sprawdzenie poprawności: Termin nie może być puste" }
            )
          end
        end
      end

      describe 'DELETE /admin/match/:id' do
        context 'valid params' do
          let(:delete_request) do
            delete "/admin/matches/#{match.id}",
                  headers: @auth_headers
          end

          it 'removes match' do
            expect { delete_request }.to change { Match.count }.by(-1)
            expect(response).to have_http_status(204)
          end
        end

        context 'invalid params' do
          let(:delete_request) do
            delete "/admin/matches/0",
                  headers: @auth_headers
          end

          it 'does not remove match' do
            expect { delete_request }.to change { Match.count }.by(0)
            expect(response).to have_http_status(404)
            expect(json).to eq({"message"=>"Couldn't find #{model_string} with 'id'=0"})
          end
        end
      end
    end
  end
end
