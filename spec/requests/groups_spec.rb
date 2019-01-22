require 'rails_helper'

RSpec.describe "Groups", type: :request do
  let!(:competition) { create(:competition) }
  let(:instance) { create(:group) }
  let(:model) { Group }
  let(:model_string) { model.to_s }
  let!(:group) { create(:group, owner: user_registered) }
  let!(:group_other_owner) { create(:group) }
  let(:type) { model.to_s.pluralize.underscore.dasherize }
  let(:users) { create_list(:user, 3) }
  let!(:user_registered) { create(:user, :registered) }

  let(:params) do
    {
      data: {
        type: type,
        attributes: attributes
      }
    }
  end

  context 'not logged in' do
    let(:auth_headers) { {} }
    include_examples 'not_logged_in_requests'
  end

  context 'registered group logged in' do
    before do
      logged_in_response = login(user_registered)
      @auth_headers = get_auth_headers(logged_in_response)
    end

    describe 'GET /groups' do
      let(:index_request) do
        get '/groups',
            headers: @auth_headers
      end

      it 'returns all instances' do
        index_request
        expect(response).to have_http_status(200)
        expect(json_data.size).to eq model.all.count
      end
    end

    describe 'GET /group/:id' do
      context 'with valid id' do
        let(:show_request) do
          get "/groups/#{group.id}",
              headers: @auth_headers
        end

        it 'returns group with id provided' do
          show_request
          expect(response).to have_http_status(200)
          expect(json_data['id']).to eq(group.id.to_s)
        end
      end

      context 'with invalid id' do
        let(:show_request) do
          get "/groups/0",
              headers: @auth_headers
        end

        it 'returns group with id provided' do
          show_request
          expect(response).to have_http_status(404)
          expect(json).to eq "message" => "Couldn't find #{model} with 'id'=0"
        end
      end
    end

    describe 'POST /groups' do
      let(:post_request) do
        post '/groups',
             params: params,
             headers: @auth_headers
      end

      context 'valid data' do
        let(:attributes) do
          {
            'name': 'New Group',
            'owner_id': user_registered.id.to_s,
            'user_ids': users.map { |u| u.id.to_s },
            'competition_ids': [competition.id.to_s]
          }
        end

        it 'creates new group' do
          expect { post_request }.to change { Group.count }.by(1)
          expect(response).to have_http_status(200)
          expect(json_relationships['owner']['data']['id']).to eq(user_registered.id.to_s)
          expect(json_relationships['competitions']['data'].map { |rel| rel['id'] }).to eq([competition.id.to_s])
          expect(json_relationships['users']['data'].map { |user| user['id'] }).to match(users.map { |u| u.id.to_s } )
        end
      end

      context 'invalid data' do
        let(:attributes) do
          {
            'name': '',
            'owner_id': '',
            'user_ids': [],
            'competition_ids': []
          }
        end

        it 'does not create new group' do
          expect { post_request }.to change { Group.count }.by(0)
          expect(response).to have_http_status(422)
          expect(json).to eq(
            { 
              "message" => "Negatywne sprawdzenie poprawności: Owner nie może być puste, Właściciel nie może być puste, Nazwa nie może być puste"
              }
          )
        end
      end
    end

    describe 'PATCH /groups/:id' do
      let(:patch_request) do
        patch "/groups/#{group.id}",
              params: params,
              headers: @auth_headers
      end

      let(:patch_request_other_user) do
        patch "/groups/#{group_other_owner.id}",
              params: params,
              headers: @auth_headers
      end

      context 'with valid data' do
        let(:new_competition) { create(:competition) }
        let(:new_group) { create(:group) }
        let(:new_played) { (Time.now + 1.day).strftime("%FT%T") }
        let(:attributes) do
          {
            'name': 'Updated Group',
            'owner_id': group.owner.id.to_s,
            'user_ids': [user_registered.id],
            'competition_ids': [new_competition.id]
          }
        end

        it 'updates group' do
          patch_request
          expect(response).to have_http_status(200)
          expect(json_relationships['owner']['data']['id']).to eq(user_registered.id.to_s)
          expect(json_relationships['competitions']['data'].map { |rel| rel['id'] }).to match([new_competition.id.to_s])
          expect(json_relationships['users']['data'].map { |user| user['id'] }).to match([user_registered.id.to_s])
         end

        it 'does not update group of other user' do
          patch_request_other_user
          expect(response).to have_http_status(403)
        end
      end

      context 'with invalid data' do
        let(:attributes) do
          {
            'name': ''
          }
        end

        it 'does not update group' do
          patch_request
          expect(response).to have_http_status(422)
          expect(json).to eq(
            { "message" => "Negatywne sprawdzenie poprawności: Nazwa nie może być puste" }
          )
        end

        it 'does not update group of other user' do
          patch_request_other_user
          expect(response).to have_http_status(403)
        end
      end
    end

    describe 'DELETE /group/:id' do
      context 'valid params' do
        let(:delete_request) do
          delete "/groups/#{group.id}",
                headers: @auth_headers
        end

        let(:delete_request_other_owner) do
          delete "/groups/#{group_other_owner.id}",
                headers: @auth_headers
        end

        it 'removes group if user is owner' do
          expect { delete_request }.to change { Group.count }.by(-1)
          expect(response).to have_http_status(204)
        end

        it 'does not remove group of other user' do
          expect { delete_request_other_owner }.to change { Group.count }.by(0)
          expect(response).to have_http_status(403)
        end
      end

      context 'invalid params' do
        let(:delete_request) do
          delete "/groups/0",
                headers: @auth_headers
        end

        it 'does not remove group' do
          expect { delete_request }.to change { Group.count }.by(0)
          expect(response).to have_http_status(404)
          expect(json).to eq({"message"=>"Couldn't find #{model_string} with 'id'=0"})
        end
      end
    end

    describe 'GET /groups/join/:token' do
      let(:token) { group_other_owner.token }

      context 'valid token' do
        let(:get_request) do
          get "/groups/#{group_other_owner.id}/join/#{token}",
                headers: @auth_headers
        end

        it 'allows user to join to group with valid token' do
          expect { get_request } .to change { GroupsUser.count }.by(1)
          expect(group_other_owner.users).to include(user_registered)
        end
      end

      context 'invalid token' do
        let(:get_request) do
          get "/groups/#{group_other_owner.id}/join/123",
                headers: @auth_headers
        end
        it 'does not allow user to join to group with valid token' do
          expect { get_request } .to change { GroupsUser.count }.by(0)
          expect(group_other_owner.users).to_not include(user_registered)
        end
      end

      context 'invalid group' do
        let(:get_request) do
          get "/groups/0/join/#{token}",
              headers: @auth_headers
        end
        it 'does not allow user to join to group with valid token' do
          get_request
          expect(json).to eq('message' => 'Group not found')
          expect { get_request } .to change { GroupsUser.count }.by(0)
          expect(group_other_owner.users).to_not include(user_registered)
        end
      end
    end
  end
end
