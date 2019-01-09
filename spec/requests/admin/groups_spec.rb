require 'rails_helper'

RSpec.describe "Groups", type: :request do
  describe "GET /groups" do
    it "returns list of the groups" do
      get groups_path
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq("application/json")
    end
  end

  describe "GET /group/:id" do
    it 'returns group with id provided' do
    end
  end

  describe "POST /groups" do
    it 'creates new group' do
    enda

    it 'adds users to group' do
    end

    it 'adds competition to group' do
    end 
  end

  describe "PATCH /group/:id" do
    it "updates group" do
    end
  end

  describe "DELETE /group/:id" do
    it "removes group" do
    end
  end
end
