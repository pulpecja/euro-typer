require 'rails_helper'

RSpec.describe "Admin::Settings", type: :request do
  let(:instance) { settings.first }
  let(:model) { Setting }
  let(:model_string) { model.to_s }
  let!(:settings) { create_list(:setting, 2) }
  let(:setting) { settings.first }
  let(:type) { model.to_s.pluralize.underscore.dasherize }
  let!(:user_admin) { create(:user, :admin) }
  let!(:user_registered) { create(:user, :registered) }

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

      describe 'GET /admin/settings' do
        let(:index_request) do
          get '/admin/settings',
              headers: @auth_headers
        end

        it 'returns all instances' do
          index_request
          expect(response).to have_http_status(200)
          expect(json_data.size).to eq model.all.count
        end
      end

      describe 'GET /admin/setting/:id' do
        context 'with valid id' do
          let(:show_request) do
            get "/admin/settings/#{setting.id}",
                headers: @auth_headers
          end

          it 'returns setting with id provided' do
            show_request
            expect(response).to have_http_status(200)
            expect(json_data['id']).to eq(setting.id.to_s)
          end
        end

        context 'with invalid id' do
          let(:show_request) do
            get "/admin/settings/0",
                headers: @auth_headers
          end

          it 'returns setting with id provided' do
            show_request
            expect(response).to have_http_status(404)
            expect(json).to eq "message" => "Couldn't find #{model} with 'id'=0"
          end
        end
      end

      describe 'POST /admin/settings' do
        let(:post_request) do
          post '/admin/settings',
               params: params,
               headers: @auth_headers
        end

        context 'valid data' do
          let(:attributes) do
            {
              'name': 'New Setting',
              'value': 1
            }
          end

          it 'creates new setting' do\
            expect { post_request }.to change { Setting.count }.by(1)
            expect(response).to have_http_status(200)
            expect(json_attributes['name']).to eq('New Setting')
          end
        end

        context 'invalid data' do
          let(:attributes) do
            {
              'name': ''
            }
          end

          it 'does not create new setting' do
            expect { post_request }.to change { Setting.count }.by(0)
            expect(response).to have_http_status(422)
            expect(json).to eq(
              { 
                "message" => "Negatywne sprawdzenie poprawności: Name nie może być puste, Value nie może być puste"
                }
            )
          end
        end
      end

      describe 'PATCH /admin/setting/:id' do
        let(:patch_request) do
          patch "/admin/settings/#{setting.id}",
                params: params,
                headers: @auth_headers
        end

        context 'with valid data' do
          let(:attributes)  do
            { "name": "New name" }
          end

          it 'updates setting' do
            patch_request
            expect(response).to have_http_status(200)
            expect(json_attributes['name']).to eq('New name')
          end
        end

        context 'with invalid data' do
          let(:attributes) do
            {
              "name": ''
            }
          end

          it 'does not update setting' do
            patch_request
            expect(response).to have_http_status(422)
            expect(json).to eq(
              { "message" => "Negatywne sprawdzenie poprawności: Name nie może być puste" }
            )
          end
        end
      end

      describe 'DELETE /admin/setting/:id' do
        context 'valid params' do
          let(:delete_request) do
            delete "/admin/settings/#{setting.id}",
                  headers: @auth_headers
          end

          it 'removes setting' do
            expect { delete_request }.to change { Setting.count }.by(-1)
            expect(response).to have_http_status(204)
          end
        end

        context 'invalid params' do
          let(:delete_request) do
            delete "/admin/settings/0",
                  headers: @auth_headers
          end

          it 'does not remove setting' do
            expect { delete_request }.to change { Setting.count }.by(0)
            expect(response).to have_http_status(404)
            expect(json).to eq({"message"=>"Couldn't find #{model_string} with 'id'=0"})
          end
        end
      end
    end
  end
end
