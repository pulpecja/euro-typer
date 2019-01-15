require 'rails_helper'

RSpec.describe "Admin::Rounds", type: :request do
  let(:competition) { create(:competition) }
  let(:instance) { rounds.first }
  let(:model) { Round }
  let(:model_string) { model.to_s }
  let(:relationships) { {} }
  let!(:rounds) { create_list(:round, 2) }
  let(:round) { rounds.first }
  let(:type) { model.to_s.pluralize.underscore.dasherize }
  let!(:user_admin) { create(:user, :admin) }
  let!(:user_registered) { create(:user, :registered) }

  let(:params) do
    {
      data: {
        type: type,
        attributes: attributes,
        relationships: relationships
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

    context 'admin logged in' do
      before do
        logged_in_response = login(user_admin)
        @auth_headers = get_auth_headers(logged_in_response)
      end

      describe 'GET /admin/rounds' do
        let(:index_request) do
          get '/admin/rounds',
              headers: @auth_headers
        end

        it 'returns all instances' do
          index_request
          expect(response).to have_http_status(200)
          expect(json_data.size).to eq model.all.count
        end
      end

      describe 'GET /admin/round/:id' do
        context 'with valid id' do
          let(:show_request) do
            get "/admin/rounds/#{round.id}",
                headers: @auth_headers
          end

          it 'returns round with id provided' do
            show_request
            expect(response).to have_http_status(200)
            expect(json_data['id']).to eq(round.id.to_s)
          end
        end

        context 'with invalid id' do
          let(:show_request) do
            get "/admin/rounds/0",
                headers: @auth_headers
          end

          it 'returns round with id provided' do
            show_request
            expect(response).to have_http_status(404)
            expect(json).to eq "message" => "Couldn't find #{model} with 'id'=0"
          end
        end
      end

      describe 'POST /admin/rounds' do
        let(:post_request) do
          post '/admin/rounds',
               params: params,
               headers: @auth_headers
        end

        context 'valid data' do
          let(:attributes) do
            {
              'name': 'New Round'
            }
          end
          let(:relationships) do
            {
              competitions: {
                data: [
                  type: 'competitions',
                  id: competition.id.to_s
                ]
              }
            }
          end

          it 'creates new round' do
            binding.pry
            expect { post_request }.to change { Round.count }.by(1)
            expect(response).to have_http_status(200)
            expect(json_attributes['name']).to eq('New Round')
          end
        end

        context 'invalid data' do
          let(:attributes) do
            {
              'name': ''
            }
          end

          it 'does not create new round' do
            expect { post_request }.to change { Round.count }.by(0)
            expect(response).to have_http_status(422)
            expect(json).to eq(
              { 
                "message" => "Negatywne sprawdzenie poprawności: Competition nie może być puste"
                }
            )
          end
        end
      end

      describe 'PATCH /admin/round/:id' do
        let(:patch_request) do
          patch "/admin/rounds/#{round.id}",
                params: params,
                headers: @auth_headers
        end

        context 'with valid data' do
          let(:started_at) { Time.now.strftime("%FT%T") }
          let(:attributes) do
            {
              "name": "New name",
              "started_at": started_at
            }
          end

          it 'updates round' do
            patch_request
            expect(response).to have_http_status(200)
            expect(json_attributes['name']).to eq('New name')
          end
        end

        context 'with invalid data' do
          let(:attributes) do
            {
              "started_at": ''
            }
          end

          it 'does not update round' do
            patch_request
            expect(response).to have_http_status(422)
            expect(json).to eq(
              { "message" => "Negatywne sprawdzenie poprawności: Rozpoczyna się nie może być puste" }
            )
          end
        end
      end

      describe 'DELETE /admin/round/:id' do
        context 'valid params' do
          let(:delete_request) do
            delete "/admin/rounds/#{round.id}",
                  headers: @auth_headers
          end

          it 'removes round' do
            expect { delete_request }.to change { Round.count }.by(-1)
            expect(response).to have_http_status(204)
          end
        end

        context 'invalid params' do
          let(:delete_request) do
            delete "/admin/rounds/0",
                  headers: @auth_headers
          end

          it 'does not remove round' do
            expect { delete_request }.to change { Round.count }.by(0)
            expect(response).to have_http_status(404)
            expect(json).to eq({"message"=>"Couldn't find #{model_string} with 'id'=0"})
          end
        end
      end
    end
  end
end
