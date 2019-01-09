require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    it "returns list of the users" do
      get users_path
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq("application/json")
    end
  end

  describe "GET /user/:id" do
    it 'returns user with id provided' do
    end
  end

  describe "POST /users" do
    it 'creates new user' do
    end
  end

  describe "PATCH /user/:id" do
    it "updates user" do
    end
  end

  describe "DELETE /user/:id" do
    it "removes user" do
    end
  end
end
