require 'rails_helper'

RSpec.describe MatchesController, type: :controller do

  let(:team) { create :team }

  before(:each) do
    @user  = create :user
    sign_in(@user, scope: :user)
  end

  describe "GET #index" do
    it "renders index" do
      get :index

      expect(response).to render_template :index
      assert_response :success
    end
  end

  describe "GET #show" do
    it "renders show" do
      get :show, { id: team.id }
      assert_response :success
      expect(response).to render_template :show
    end
  end
end
