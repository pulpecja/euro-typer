require 'rails_helper'

RSpec.describe 'Admin::Teams', type: :request do
  let(:instance) { teams.first }
  let(:model) { Team }
  let(:model_string) { model.to_s }
  let(:photo) do
     "data:image/png;base64," + photo_data
  end
  let(:photo_data) { Base64.encode64(file_fixture("flag_pl.png").read) }
  let!(:teams) { create_list(:team, 2) }
  let(:team) { teams.first }
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
      include_examples 'admin_namespace_not_logged_in_requests'
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

      describe 'GET /admin/teams' do
        let(:default_per_page) { 20 }
        before do
          create_list(:team, 40)
        end

        context 'without pagination params' do
          let(:index_request) do
            get '/admin/teams',
                headers: @auth_headers
          end

          let(:index_request_all) do
            get '/admin/teams',
                headers: @auth_headers,
                params: {
                  all: true
                }
          end

          it 'returns first 20 instances if no pagination params sent' do
            index_request
            expect(response).to have_http_status(200)
            expect(json_data.size).to eq default_per_page
          end

          it 'returns all instances if parameter all has sent' do
            index_request_all
            expect(response).to have_http_status(200)
            expect(json_data.size).to eq model.all.count
          end
        end

        context 'with pagination params' do
          let(:index_request) do
            get '/admin/teams',
                headers: @auth_headers
          end

          let(:index_request_page_in_the_middle) do
            get '/admin/teams?page=2',
                headers: @auth_headers
          end

          let(:index_request_last_page) do
            get '/admin/teams?page=3&per_page=20',
              headers: @auth_headers
          end

          let(:index_request_one_per_page) do
            get '/admin/teams?per_page=1',
              headers: @auth_headers
          end

          it 'returns pagination links and 20 records per page' do
            index_request
            expected_links = {
              "last" => "http://www.example.com/admin/teams?page=3",
              "next" => "http://www.example.com/admin/teams?page=2",
              "self" => "http://www.example.com/admin/teams?"
            }

            expected_meta = {
              "current_page" => 1,
              "per_page" => 20,
              "total_pages" => 3,
              "total_records" => Team.all.size
            }

            expect(response).to have_http_status(200)
            expect(json['links']).to eq(expected_links)
            expect(json['meta']).to eq(expected_meta)
            expect(json_data.size).to eq default_per_page
          end

          it 'returns first, prev, next, self and last links' do
            expected_links = {
              "first" => "http://www.example.com/admin/teams?",
              "last" => "http://www.example.com/admin/teams?page=3",
              "next" => "http://www.example.com/admin/teams?page=3",
              "prev" => "http://www.example.com/admin/teams?",
              "self" => "http://www.example.com/admin/teams?page=2",
            }

            expected_meta = {
              "current_page" => 2,
              "per_page" => 20,
              "total_pages" => 3,
              "total_records" => Team.all.size
            }

            index_request_page_in_the_middle
            expect(json['links']).to eq(expected_links)
            expect(json['meta']).to eq(expected_meta)
            expect(json_data.size).to eq default_per_page
          end

          it 'returns last 2 records' do
            expected_links = {
              "first" => "http://www.example.com/admin/teams?",
              "prev" => "http://www.example.com/admin/teams?page=2",
              "self" => "http://www.example.com/admin/teams?page=3"
            }
            expected_meta = {
              "current_page" => 3,
              "per_page" => 20,
              "total_pages" => 3,
              "total_records" => Team.all.size
            }

            index_request_last_page
            expect(json['links']).to eq(expected_links)
            expect(json['meta']).to eq(expected_meta)
            expect(json_data.size).to eq 2
          end

          it 'returns 1 record if per_page params sent' do
            expected_links = {
              "last" => "http://www.example.com/admin/teams?page=42&per_page=1",
              "next" => "http://www.example.com/admin/teams?page=2&per_page=1",
              "self" => "http://www.example.com/admin/teams?per_page=1"
            }
            expected_meta = {
              "current_page" => 1,
              "per_page" => 1,
              "total_pages" => 42,
              "total_records" => Team.all.size
            }

            index_request_one_per_page
            expect(json['links']).to eq(expected_links)
            expect(json['meta']).to eq(expected_meta)
            expect(json_data.size).to eq 1
          end
        end
      end

      describe 'GET /admin/team/:id' do
        context 'with valid id' do
          let(:show_request) do
            get "/admin/teams/#{team.id}",
                headers: @auth_headers
          end

          it 'returns team with id provided' do
            show_request
            expect(response).to have_http_status(200)
            expect(json_data['id']).to eq(team.id.to_s)
          end
        end

        context 'with invalid id' do
          let(:show_request) do
            get "/admin/teams/0",
                headers: @auth_headers
          end

          it 'returns team with id provided' do
            show_request
            expect(response).to have_http_status(404)
            expect(json).to eq "message" => "Couldn't find #{model} with 'id'=0"
          end
        end
      end

      describe 'POST /admin/teams' do
        let(:post_request) do
          post '/admin/teams',
               params: params,
               headers: @auth_headers
        end

        context 'valid data' do
          let(:attributes) do
            {
              'name': 'Nowy zespol',
              'name_en': 'New team',
              'photo': photo
            }
          end

          it 'creates new team' do
            VCR.use_cassette('team create with photo') do
              expect { post_request }.to change { Team.count }.by(1)
              expect(response).to have_http_status(200)
              expect(json_attributes['name']).to eq('Nowy zespol')
              expect(json_attributes['photo']['url']).to be
              expect(json_attributes['photo']['medium']).to be
              expect(json_attributes['photo']['mini']).to be
              expect(json_attributes['photo']['thumb']).to be
            end
          end
        end

        context 'invalid data' do
          let(:attributes) do
            {
              'name': '',
              'name_en': ''
            }
          end

          it 'does not create new team' do
            expect { post_request }.to change { Team.count }.by(0)
            expect(response).to have_http_status(422)
            expect(json).to eq(
              { "message" => "Negatywne sprawdzenie poprawności: Nazwa nie może być puste" }
            )
          end
        end

      end

      describe 'PATCH /admin/team/:id' do
        let(:patch_request) do
          patch "/admin/teams/#{team.id}",
                params: params,
                headers: @auth_headers
        end

        context 'with valid data' do
          let(:attributes)  do
            { "name": "New name" }
          end

          it 'updates team' do
            patch_request
            expect(response).to have_http_status(200)
            expect(json_attributes['name']).to eq('New name')
          end
        end

        context 'with invalid data' do
          let(:attributes) do
            {
              "name": '',
              "name_en": ''
            }
          end

          it 'does not update team' do
            patch_request
            expect(response).to have_http_status(422)
            expect(json).to eq(
              { "message" => "Negatywne sprawdzenie poprawności: Nazwa nie może być puste" }
            )
          end
        end
      end

      describe 'DELETE /admin/team/:id' do
        context 'valid params' do
          let(:delete_request) do
            delete "/admin/teams/#{team.id}",
                  headers: @auth_headers
          end

          it 'removes team' do
            expect { delete_request }.to change { Team.count }.by(-1)
            expect(response).to have_http_status(204)
          end
        end

        context 'invalid params' do
          let(:delete_request) do
            delete "/admin/teams/0",
                  headers: @auth_headers
          end

          it 'does not remove team' do
            expect { delete_request }.to change { Team.count }.by(0)
            expect(response).to have_http_status(404)
            expect(json).to eq({"message"=>"Couldn't find #{model_string} with 'id'=0"})
          end
        end
      end
    end
  end
end
