require 'rails_helper'

RSpec.describe "Settings", type: :request do
  describe "GET /settings" do
    it "returns list of the settings" do
      get settings_path
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq("application/json")
    end
  end

  describe "GET /setting/:id" do
    it 'returns setting with id provided' do
    end
  end

  describe "POST /settings" do
    it 'creates new setting' do
    end
  end

  describe "PATCH /setting/:id" do
    it "updates setting" do
    end
  end

  describe "DELETE /setting/:id" do
    it "removes setting" do
    end
  end
end
