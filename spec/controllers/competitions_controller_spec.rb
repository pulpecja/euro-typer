require 'rails_helper'

RSpec.describe CompetitionsController, type: :controller do

  before(:each) do
    @user  = create :user
    @group = create :group
    sign_in(@user, scope: :user)
  end

  let(:competition) { create :competition }

  describe "GET #index" do
    it "renders index" do
      get :index, group_id: @group.id

      expect(response).to render_template :index
      assert_response :success
    end
  end

  describe "GET #show" do
    it "renders show" do
      get :show, { id: competition.id }
      assert_response :success
      expect(response).to render_template :show
    end
  end
end
