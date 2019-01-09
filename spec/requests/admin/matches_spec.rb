require 'rails_helper'

RSpec.describe "Matches", type: :request do
  describe "GET /matches" do
    it "returns list of the matchs" do
      get matchs_path
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq("application/json")
    end
  end

  describe "GET /match/:id" do
    it 'returns match with id provided' do
    end
  end

  describe "POST /matches" do
    it 'creates new match' do
    end
  end

  describe "PATCH /match/:id" do
    it "updates match" do
    end
  end

  describe "DELETE /match/:id" do
    it "removes match" do
    end
  end
end
