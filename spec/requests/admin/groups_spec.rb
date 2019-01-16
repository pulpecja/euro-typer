require 'rails_helper'

RSpec.describe "Admin::Groups", type: :request do
  let(:competitions) { create_list(:competition, 3)}
  let(:instance) { groups.first }
  let(:group) { groups.first }
  let(:groups) { create_list(:group, 3)}
  let(:model) { Group }
  let(:model_string) { model.to_s }
  let!(:groups) { create_list(:group, 2) }
  let(:group) { groups.first }
  let(:round) { create(:round)}
  let(:type) { model.to_s.pluralize.underscore.dasherize }
  let!(:user_admin) { create(:user, :admin) }
  let!(:user_registered) { create(:user, :registered) }
  let(:users) { create_list(:user, 3) }

  let(:params) do
    {
      data: {
        type: type,
        attributes: attributes
      }
    }
  end

  context 'admin namespace' do
    context 'not logged in' do
      let(:auth_headers) { {} }
      include_examples 'admin_namespace_unauthorized_requests'
    end

    context 'registered user logged in' do
      before do
        @logged_in_response = login(user_registered)
      end

      let(:auth_headers) { get_auth_headers(@logged_in_response) }

      include_examples 'admin_namespace_unauthorized_requests'
    end

    context 'admin logged in' do
      before do
        logged_in_response = login(user_admin)
        @auth_headers = get_auth_headers(logged_in_response)
      end

      describe 'GET /admin/groups' do
        let(:index_request) do
          get '/admin/groups',
              headers: @auth_headers
        end

        it 'returns all instances' do
          index_request
          expect(response).to have_http_status(200)
          expect(json_data.size).to eq model.all.count
        end
      end

      describe 'GET /admin/groups/:id' do
        context 'with valid id' do
          let(:show_request) do
            get "/admin/groups/#{group.id}",
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
            get "/admin/groups/0",
                headers: @auth_headers
          end

          it 'returns group with id provided' do
            show_request
            expect(response).to have_http_status(404)
            expect(json).to eq "message" => "Couldn't find #{model} with 'id'=0"
          end
        end
      end

      describe 'POST /admin/groups' do
        let(:post_request) do
          post '/admin/groups',
               params: params,
               headers: @auth_headers
        end

        context 'valid data' do
          let(:attributes) do
            {
              'name': 'New Group',
              'owner_id': user_admin.id.to_s,
              'user_ids': users.map { |u| u.id.to_s},
              'competition_ids': competitions.map { |u| u.id.to_s},
            }
          end

          it 'creates new group' do
            expect { post_request }.to change { Group.count }.by(1)
            expect(response).to have_http_status(200)
            expect(json_relationships['owner']['data']['id']).to eq(user_admin.id.to_s)
            expect(json_relationships['competitions']['data'].map { |rel| rel['id'] }).to match(competitions.map { |c| c.id.to_s } )
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

      describe 'PATCH /admin/groups/:id' do
        let(:patch_request) do
          patch "/admin/groups/#{group.id}",
                params: params,
                headers: @auth_headers
        end

        context 'with valid data' do
          let(:new_played) { (Time.now + 1.day).strftime("%FT%T") }
          let(:new_group) { create(:group) }
          let(:attributes) do
            {
              'name': 'Updated Group',
              'owner_id': user_registered.id.to_s,
              'user_ids': [user_registered.id],
              'competition_ids': [competitions.first.id],
            }
          end

          it 'updates group' do
            patch_request
            expect(response).to have_http_status(200)
            expect(json_relationships['owner']['data']['id']).to eq(user_registered.id.to_s)
            expect(json_relationships['competitions']['data'].map { |rel| rel['id'] }).to match([competitions.first.id.to_s])
            expect(json_relationships['users']['data'].map { |user| user['id'] }).to match([user_registered.id.to_s])
           end
        end

        context 'with invalid data' do
          let(:attributes) do
            {
              'name': '',
            }
          end

          it 'does not update group' do
            patch_request
            expect(response).to have_http_status(422)
            expect(json).to eq(
              { "message" => "Negatywne sprawdzenie poprawności: Nazwa nie może być puste" }
            )
          end
        end
      end

      describe 'DELETE /admin/group/:id' do
        context 'valid params' do
          let(:delete_request) do
            delete "/admin/groups/#{group.id}",
                  headers: @auth_headers
          end

          it 'removes group' do
            expect { delete_request }.to change { Group.count }.by(-1)
            expect(response).to have_http_status(204)
          end
        end

        context 'invalid params' do
          let(:delete_request) do
            delete "/admin/groups/0",
                  headers: @auth_headers
          end

          it 'does not remove group' do
            expect { delete_request }.to change { Group.count }.by(0)
            expect(response).to have_http_status(404)
            expect(json).to eq({"message"=>"Couldn't find #{model_string} with 'id'=0"})
          end
        end
      end
    end
  end
end
