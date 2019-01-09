require 'rails_helper'

RSpec.describe "Competitions", type: :request do
  describe "GET /competitions" do
    it "returns list of the competitions" do
      get competitions_path
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq("application/json")
    end
  end

  describe "GET /competition/:id" do
    it 'returns competition with id provided' do
    end
  end

  describe "POST /competitions" do
    it 'creates new competition' do
    end
  end

  describe "PATCH /competition/:id" do
    it "updates competition" do
    end
  end

  describe "DELETE /competition/:id" do
    it "removes competition" do
    end
  end
end
