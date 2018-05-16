require 'rails_helper'

RSpec.describe GroupsController, type: :controller do

  before(:each) do
    @user  = create :user
    sign_in(@user, scope: :user)
  end

  let(:user)        { create :user }
  let(:group)       { create :group }
  let(:competition) { create :competition }
  let(:valid_attributes) { { name: 'Warszawa',
                             competition_ids: [competition.id],
                             owner_id: user.id } }
  let(:invalid_attributes) { { name: '' } }

  describe "GET #index" do
    it "renders index" do
      get :index, group_id: group.id

      expect(response).to render_template :index
      assert_response :success
    end
  end

  describe "GET #show" do
    it "renders show" do
      get :show, { id: group.id }
      assert_response :success
      expect(response).to render_template :show
    end

    it "GET #new" do
      get :new

      expect(response).to render_template :new
      assert_response :success
      expect(assigns(:group)).to be_a_new(Group)
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new group" do
          expect {
            post :create, { group: valid_attributes }

          }.to change(Group, :count).by(1)
        end

        it "assigns a newly created group as @group" do
          post :create, { group: valid_attributes}
          expect(assigns(:group)).to be_a(Group)
          expect(assigns(:group)).to be_persisted
          expect(assigns(:group).competitions.count).to eq(1)
          expect(assigns(:group).competitions).to eq([competition])
          expect(assigns(:group).users.count).to eq(1)
          expect(assigns(:group).users).to include(@user)
        end

        it "redirects to the created group" do
          post :create, { group: valid_attributes }
          expect(response).to redirect_to(Group.last)
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved group as @group" do
          post :create, { group: invalid_attributes }

          expect(assigns(:group)).to be_a_new(Group)
        end

        it "re-renders the 'new' template" do
          post :create, { group: invalid_attributes }
          expect(response).to render_template("new")
        end
      end
    end

    describe "GET #edit" do
      it 'can edit his own group' do
        group.owner = @user
        group.save
        get :edit, { id: group.id }

        expect(response).to render_template :edit
        assert_response :success
        expect(assigns(:group)).to eq(group)
      end

      it "cannot edit someone else's group" do
        get :edit, { id: group.id }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end
    end

    describe "GET #destroy" do
      it 'can destroy his own group' do
        group.owner = @user
        group.save
        expect {
          get :destroy, { id: group.id }

          expect(response).to redirect_to groups_path
        }.to change(Group, :count).by(-1)
      end

      it "cannot destroy someone else's group" do
        get :destroy, { id: group.id }

        expect {
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('You are not authorized to access this page.')
        }.not_to change(Group, :count)
      end
    end

    describe 'GET #join' do
      it 'adds user to group' do
        expect(group.users).not_to include(@user)
        get :join, { group_id: group.id, token: group.token }
        expect(group.reload.users).to include(@user)
      end
    end
  end
end
