require 'rails_helper'

RSpec.describe "Rounds", type: :request do
  describe "GET /rounds" do
    it "returns list of the rounds" do
      get rounds_path
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq("application/json")
    end
  end

  describe "GET /round/:id" do
    it 'returns round with id provided' do
    end
  end

  describe "POST /rounds" do
    it 'creates new round' do
    end
  end

  describe "PATCH /round/:id" do
    it "updates round" do
    end
  end

  describe "DELETE /round/:id" do
    it "removes round" do
    end
  end
end
