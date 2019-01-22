require 'rails_helper'

RSpec.describe "Matches", type: :request do
  let(:instance) { matches.first }
  let(:model) { Match }
  let(:model_string) { model.to_s }
  let!(:matches) { create_list(:match, 2) }
  let(:match) { matches.first }
  let(:type) { model.to_s.pluralize.underscore.dasherize }
  let!(:user_registered) { create(:user, :registered) }

  context 'not logged in' do
    let(:auth_headers) { {} }
    include_examples 'not_logged_in_requests'
  end

  context 'registered match logged in' do
    before do
      logged_in_response = login(user_registered)
      @auth_headers = get_auth_headers(logged_in_response)
    end

    describe 'GET /matches' do
      let(:index_request) do
        get '/matches',
            headers: @auth_headers
      end

      it 'returns all instances' do
        index_request
        expect(response).to have_http_status(200)
        expect(json_data.size).to eq model.all.count
      end
    end

    describe 'GET /match/:id' do
      context 'with valid id' do
        let(:show_request) do
          get "/matches/#{match.id}",
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
          get "/matches/0",
              headers: @auth_headers
        end

        it 'returns match with id provided' do
          show_request
          expect(response).to have_http_status(404)
          expect(json).to eq "message" => "Couldn't find #{model} with 'id'=0"
        end
      end
    end
  end
end
