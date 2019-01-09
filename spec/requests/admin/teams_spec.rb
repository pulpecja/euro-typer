require 'rails_helper'

RSpec.describe "Teams", type: :request do
  describe "GET /teams" do
    it "returns list of the teams" do
      get teams_path
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq("application/json")
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
