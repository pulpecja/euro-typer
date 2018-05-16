require 'rails_helper'

RSpec.describe Admin::GroupsController, type: :controller do

  let(:competition) { create :competition }
  let(:first_group) { create :group }
  let(:user)        { create :user }
  let(:second_user) { create :user }
  let(:valid_attributes) { { name: 'Warszawa',
                             user_ids: [user.id],
                             competition_ids: [competition.id],
                             owner_id: second_user.id } }
  let(:invalid_attributes) { { name: '' } }

  describe 'non-admin user' do
    before(:each) do
      @user = create :user
      sign_in(@user, scope: :user)
    end

    it "can't enter index page" do
      get :index

      expect(response).not_to render_template :index
      assert_response :redirect
      expect(flash[:alert]).to eq('You are not authorized to access this page.')
    end

    it "can't access new page" do
      get :new

      expect(response).not_to render_template :new
      assert_response :redirect
      expect(flash[:alert]).to eq('You are not authorized to access this page.')
    end

    it "can access edit page" do
      get :edit, { id: first_group.id }

      expect(response).not_to render_template :edit
      assert_response :redirect
      expect(flash[:alert]).to eq('You are not authorized to access this page.')
    end

    describe "POST #create" do
      context "with valid params" do
        it "doesn't create a new group" do
          expect {
            post :create, { group: valid_attributes }
          }.not_to change(Group, :count)
        end

        it "doesn't assign a newly created group as @group" do
          post :create, { group: valid_attributes}
          expect(assigns(:group)).to be_nil
        end

        it "redirects to root path" do
          post :create, { group: valid_attributes }
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('You are not authorized to access this page.')
        end
      end

      context "with invalid params" do
        it "doesn't assign a newly created but unsaved group as @group" do
          post :create, { group: invalid_attributes }

          expect(assigns(:group)).to be_nil
        end

        it "redirects to root path" do
          post :create, { group: invalid_attributes }
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('You are not authorized to access this page.')
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) { { name: 'Lublin' } }


        it "doesn't update the requested group" do
          put :update, { id: first_group.id, group: new_attributes}
          first_group.reload
          expect(first_group.name).to eq('Kraków')
        end

        it "doesn't assign the requested group as @group" do
          put :update, { id: first_group.id, group: valid_attributes}
          expect(assigns(:group)).to be_nil
        end

        it "redirects to the root path" do
          put :update, { id: first_group.id, group: valid_attributes}
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('You are not authorized to access this page.')
        end
      end

      context "with invalid params" do
        it "doesn't assign the group as @group" do
          put :update, { id: first_group.id, group: invalid_attributes}
          expect(assigns(:group)).to be_nil
        end

        it "redirects to root path" do
          put :update, { id: first_group.id, group: invalid_attributes}
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('You are not authorized to access this page.')
        end
      end
    end

    describe "DELETE #destroy" do
      it "doesn't destroy the requested group" do
        group = create :group
        expect {
          delete :destroy, { id: group.id }
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('You are not authorized to access this page.')
        }.not_to change(Group, :count)
      end
    end
  end

  describe 'admin-user' do
    before(:each) do
      @user  = create :user, :admin
      sign_in(@user, scope: :user)
    end

    it "can access index page" do
      get :index

      expect(response).to render_template :index
      assert_response :success
    end

    it "can access new page" do
      get :new

      expect(response).to render_template :new
      assert_response :success
      expect(assigns(:group)).to be_a_new(Group)
    end

    it "can access edit page" do
      get :edit, { id: first_group.id }

      expect(response).to render_template :edit
      assert_response :success
      expect(assigns(:group)).to eq(first_group)
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
          expect(assigns(:group).competitions).to eq([competition])
          expect(assigns(:group).users.count).to eq(2)
          expect(assigns(:group).users).to include(second_user)
        end

        it "redirects to the created group" do
          post :create, { group: valid_attributes }
          expect(response).to redirect_to(admin_groups_path)
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

    describe "PUT #update" do
      context "with valid params" do

        it "updates the requested group" do
          put :update, { id: first_group.id, group: valid_attributes }
          first_group.reload
          expect(first_group.name).to eq('Warszawa')
        end

        it "assigns the requested group as @group" do
          put :update, { id: first_group.id, group: valid_attributes }
          expect(assigns(:group)).to eq(first_group)
        end

        it "redirects to the group" do
          put :update, { id: first_group.id, group: valid_attributes }
          expect(response).to redirect_to(admin_groups_path)
        end
      end

      context "with invalid params" do
        it "assigns the group as @group" do
          put :update, { id: first_group.id, group: invalid_attributes}
          expect(assigns(:group)).to eq(first_group)
        end

        it "re-renders the 'edit' template" do
          put :update, { id: first_group.id, group: invalid_attributes}
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested group" do
        group = create :group
        expect {
          delete :destroy, { id: group.id }
          expect(response).to redirect_to(admin_groups_url)
        }.to change(Group, :count).by(-1)
      end
    end
  end
end