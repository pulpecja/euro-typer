require 'rails_helper'

RSpec.describe Admin::CompetitionsController, type: :controller do

  let(:first_competition) { create :competition }
  let(:valid_attributes) { { name: 'Mistrzostwa Europy',
                             year: 2016,
                             place: 'Francja' } }
  let(:invalid_attributes) { { name: '',
                               year: '',
                               place: '' } }

  describe 'non-admin user' do
    before(:each) do
      @user  = create :user
      @group = create :group
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
      get :edit, { id: first_competition.id }

      expect(response).not_to render_template :edit
      assert_response :redirect
      expect(flash[:alert]).to eq('You are not authorized to access this page.')
    end

    describe "POST #create" do
      context "with valid params" do
        it "doesn't create a new Competition" do
          expect {
            post :create, { competition: valid_attributes }
          }.not_to change(Competition, :count)
        end

        it "doesn't assign a newly created competition as @competition" do
          post :create, { competition: valid_attributes}
          expect(assigns(:competition)).to be_nil
        end

        it "redirects to root path" do
          post :create, { competition: valid_attributes }
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('You are not authorized to access this page.')
        end
      end

      context "with invalid params" do
        it "doesn't assign a newly created but unsaved competition as @competition" do
          post :create, { competition: invalid_attributes }

          expect(assigns(:competition)).to be_nil
        end

        it "redirects to root path" do
          post :create, { competition: invalid_attributes }
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('You are not authorized to access this page.')
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) { { name: 'Nowe Mistrzostwa',
                                 year: 2020,
                                 place: 'Belgia' } }


        it "doesn't update the requested competition" do
          put :update, { id: first_competition.id, competition: new_attributes}
          first_competition.reload
          expect(first_competition.name).to eq('Mistrzostwa Świata')
          expect(first_competition.year).to eq(2018)
          expect(first_competition.place).to eq('Rosja')
        end

        it "doesn't assign the requested competition as @competition" do
          put :update, { id: first_competition.id, competition: valid_attributes}
          expect(assigns(:competition)).to be_nil
        end

        it "redirects to the root path" do
          put :update, { id: first_competition.id, competition: valid_attributes}
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('You are not authorized to access this page.')
        end
      end

      context "with invalid params" do
        it "doesn't assign the competition as @competition" do
          put :update, { id: first_competition.id, competition: invalid_attributes}
          expect(assigns(:competition)).to be_nil
        end

        it "redirects to root path" do
          put :update, { id: first_competition.id, competition: invalid_attributes}
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('You are not authorized to access this page.')
        end
      end
    end

    describe "DELETE #destroy" do
      it "doesn't destroy the requested competition" do
        competition = create :competition, :no_rounds
        expect {
          delete :destroy, { id: competition.id }
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('You are not authorized to access this page.')
        }.not_to change(Competition, :count)
      end

      it "does not destroy the competition with rounds" do
          delete :destroy, { id: first_competition.id }
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end
    end
  end

  describe 'admin-user' do
    before(:each) do
      @user  = create :user, :admin
      @group = create :group
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
      expect(assigns(:competition)).to be_a_new(Competition)
    end

    it "can access edit page" do
      get :edit, { id: first_competition.id }

      expect(response).to render_template :edit
      assert_response :success
      expect(assigns(:competition)).to eq(first_competition)
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Competition" do
          expect {
            post :create, { competition: valid_attributes }
          }.to change(Competition, :count).by(1)
        end

        it "assigns a newly created competition as @competition" do
          post :create, { competition: valid_attributes}
          expect(assigns(:competition)).to be_a(Competition)
          expect(assigns(:competition)).to be_persisted
        end

        it "redirects to the created competition" do
          post :create, { competition: valid_attributes }
          expect(response).to redirect_to(admin_competitions_path)
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved competition as @competition" do
          post :create, { competition: invalid_attributes }

          expect(assigns(:competition)).to be_a_new(Competition)
        end

        it "re-renders the 'new' template" do
          post :create, { competition: invalid_attributes }
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) { { name: 'Nowe Mistrzostwa',
                                 year: 2020,
                                 place: 'Belgia' } }


        it "updates the requested competition" do
          put :update, { id: first_competition.id, competition: new_attributes}
          first_competition.reload
          expect(first_competition.name).to eq('Nowe Mistrzostwa')
          expect(first_competition.year).to eq(2020)
          expect(first_competition.place).to eq('Belgia')
        end

        it "assigns the requested competition as @competition" do
          put :update, { id: first_competition.id, competition: valid_attributes}
          expect(assigns(:competition)).to eq(first_competition)
        end

        it "redirects to the competition" do
          put :update, { id: first_competition.id, competition: valid_attributes}
          expect(response).to redirect_to(admin_competitions_path)
        end
      end

      context "with invalid params" do
        it "assigns the competition as @competition" do
          put :update, { id: first_competition.id, competition: invalid_attributes}
          expect(assigns(:competition)).to eq(first_competition)
        end

        it "re-renders the 'edit' template" do
          put :update, { id: first_competition.id, competition: invalid_attributes}
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested competition" do
        competition = create :competition, :no_rounds
        expect {
          delete :destroy, { id: competition.id }
          expect(response).to redirect_to(admin_competitions_url)
        }.to change(Competition, :count).by(-1)
      end

      it "does not destroy the competition with rounds" do
        expect {
          delete :destroy, { id: first_competition.id }
          expect(response).to redirect_to(admin_competitions_url)
        }.not_to change(Competition, :count)
      end
    end
  end
end