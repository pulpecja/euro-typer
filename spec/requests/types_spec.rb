require 'rails_helper'

RSpec.describe "Types", type: :request do
  let!(:competition) { create(:competition) }
  let(:instance) { create(:type) }
  let(:model) { Type }
  let(:model_string) { model.to_s }
  let(:match) { create(:match) }
  let!(:match_type) { create(:type, user: user_registered, match: match) }
  let!(:match_type_other_user) { create(:type, user: users.first) }
  let(:type) { model.to_s.pluralize.underscore.dasherize }
  let(:users) { create_list(:user, 3) }
  let!(:user_registered) { create(:user, :registered) }

  let(:params) do
    {
      data: {
        type: type,
        attributes: attributes
      }
    }
  end

  context 'not logged in' do
    let(:auth_headers) { {} }
    include_examples 'unauthorized_requests'
  end

  context 'registered type logged in' do
    before do
      logged_in_response = login(user_registered)
      @auth_headers = get_auth_headers(logged_in_response)
      create(:setting, :end_of_voting)
    end

    describe 'GET /types' do
      let(:index_request) do
        get '/types',
            headers: @auth_headers
      end

      it 'returns all instances for currently logged in user' do
        index_request
        expect(response).to have_http_status(200)
        expect(json_data.size).to eq model.all.by_user(user_registered).size
        expect(json_data.map{ |e| e['attributes']['user_id'].to_s }.uniq).to eq([user_registered.id.to_s])
      end
    end

    describe 'GET /type/:id' do
      context 'with valid id' do
        let(:show_request) do
          get "/types/#{match_type.id}",
              headers: @auth_headers
        end

        it 'returns type with id provided' do
          show_request
          expect(response).to have_http_status(200)
          expect(json_data['id']).to eq(match_type.id.to_s)
        end
      end

      context 'with invalid id' do
        let(:show_request) do
          get "/types/0",
              headers: @auth_headers
        end

        it 'returns type with id provided' do
          show_request
          expect(response).to have_http_status(404)
          expect(json).to eq "message" => "Couldn't find #{model} with 'id'=0"
        end
      end
    end

    describe 'POST /types' do
      let(:first_score) { 1 }
      let(:second_score) { 2 }
      let(:post_request) do
        post '/types',
             params: params,
             headers: @auth_headers
      end

      context 'valid data' do
        let(:attributes) do
          {
            'match_id': match.id.to_s,
            'user_id': user_registered.id.to_s,
            'first_score': first_score,
            'second_score': second_score
          }
        end

        it 'creates new type' do
          expect { post_request }.to change { Type.count }.by(1)
          expect(response).to have_http_status(200)
          expect(json_relationships['user']['data']['id']).to eq(user_registered.id.to_s)
          expect(json_relationships['match']['data']['id']).to eq(match.id.to_s)
          expect(json_attributes['first_score']).to eq(first_score)
          expect(json_attributes['second_score']).to eq(second_score)
        end
      end

      context 'invalid data' do
        let(:attributes) do
          {
            'match_id': '',
            'user_id': '',
            'first_score': '',
            'second_score': ''
          }
        end

        it 'does not create new type' do
          expect { post_request }.to change { Type.count }.by(0)
          expect(response).to have_http_status(422)
          expect(json).to eq(
            { 
              "message" => "Negatywne sprawdzenie poprawności: Match nie może być puste, User nie może być puste, User nie może być puste, Match nie może być puste"
              }
          )
        end
      end
    end

    describe 'PATCH /types/:id' do
      let(:patch_request) do
        patch "/types/#{match_type.id}",
              params: params,
              headers: @auth_headers
      end

      let(:patch_request_other_user) do
        patch "/types/#{match_type_other_user.id}",
              params: params,
              headers: @auth_headers
      end

      context 'with valid data' do
        let(:new_first_score) { 4 }
        let(:new_second_score) { 5 }
        let(:attributes) do
          {
            'first_score': new_first_score.to_s,
            'second_score': new_second_score.to_s
          }
        end

        it 'updates type' do
          patch_request
          expect(response).to have_http_status(200)
          expect(json_attributes['first_score']).to eq(new_first_score)
          expect(json_attributes['second_score']).to eq(new_second_score)
         end

        it 'does not update type of other user' do
          patch_request_other_user
          expect(response).to have_http_status(403)
        end
      end

      context 'with invalid data' do
        let(:attributes) do
          {
            'first_score': 'string',
            'second_score': 'string'
          }
        end

        it 'does update type, set scores to 0' do
          # It is happening, bc of type_cast in controller,
          # if in db value is stored as an Integer,
          # controller cast type to Integer, string.to_i gives 0
          patch_request
          expect(response).to have_http_status(200)
          expect(json_attributes['first_score']).to eq(0)
          expect(json_attributes['second_score']).to eq(0)
        end

        it 'does not update type of other user' do
          patch_request_other_user
          expect(response).to have_http_status(403)
        end
      end
    end

    describe 'DELETE /type/:id' do
      context 'valid params' do
        let(:delete_request) do
          delete "/types/#{match_type.id}",
                headers: @auth_headers
        end

        let(:delete_request_other_user) do
          delete "/types/#{match_type_other_user.id}",
                headers: @auth_headers
        end

        it 'removes type if user is user' do
          expect { delete_request }.to change { Type.count }.by(-1)
          expect(response).to have_http_status(204)
        end

        it 'does not remove type of other user' do
          expect { delete_request_other_user }.to change { Type.count }.by(0)
          expect(response).to have_http_status(403)
        end
      end

      context 'invalid params' do
        let(:delete_request) do
          delete "/types/0",
                headers: @auth_headers
        end

        it 'does not remove type' do
          expect { delete_request }.to change { Type.count }.by(0)
          expect(response).to have_http_status(404)
          expect(json).to eq({"message"=>"Couldn't find #{model_string} with 'id'=0"})
        end
      end
    end
  end
end
