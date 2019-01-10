require 'rails_helper'

RSpec.describe "Teams", type: :request do
  let(:user) { create(:user, :admin) }
  let(:model) { Team }
  let(:teams) { create_list(:team, 2) }

  context 'admin namespace' do
    before do
      logged_in_response = login(user)
      @auth_headers = get_auth_headers(logged_in_response)
    end

    describe "GET /teams" do
      let(:index_request) {
        get '/admin/teams',
        params: {},
        headers: @auth_headers
      }

      it "returns list of the teams" do
        index_request
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json")
      end

      it 'returns the correct status code' do
        index_request
        expect(response.status).to eq 200
      end

      it 'returns all instances' do
        index_request
        expect(json_data.size).to eq model.all.count
      end
    end

    describe "GET /team/:id" do
      it 'returns team with id provided' do
      end
    end

    describe "POST /teams" do
      it 'creates new team' do
      end
    end

    describe "PATCH /team/:id" do
      it "updates team" do
      end
    end

    describe "DELETE /team/:id" do
      it "removes team" do
      end
    end
  end
end
