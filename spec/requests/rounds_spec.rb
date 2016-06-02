require 'rails_helper'

RSpec.describe "Rounds", type: :request do
  describe "GET /rounds" do
    it "works! (now write some real specs)" do
      get rounds_path
      expect(response).to have_http_status(200)
    end
  end
end
