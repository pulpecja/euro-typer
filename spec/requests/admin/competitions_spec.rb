require 'rails_helper'

RSpec.describe "Competitions", type: :request do
  let(:instance) { competitions.first }
  let(:model) { Competition }
  let(:model_string) { model.to_s }
  let!(:competitions) { create_list(:competition, 2) }
  let(:competition) { competitions.first }
  let(:type) { model.to_s.pluralize.underscore.dasherize }
  let!(:user_admin) { create(:user, :admin) }
  let!(:user_registered) { create(:user, :registered) }

  let(:params) do
    {
      data: {
        type: type,
        attributes: attributes,
        relationships: {}
      }
    }
  end

  context 'admin namespace' do
    context 'not logged in' do
      let(:auth_headers) { {} }
      include_examples 'unauthorized_requests'
    end

    context 'registered user logged in' do
      before do
        @logged_in_response = login(user_registered)
      end

      let(:auth_headers) { get_auth_headers(@logged_in_response) }

      include_examples 'unauthorized_requests'
    end

    context 'admin logged in' do
      before do
        logged_in_response = login(user_admin)
        @auth_headers = get_auth_headers(logged_in_response)
      end

      describe 'GET /admin/competitions' do
        let(:index_request) do
          get '/admin/competitions',
              headers: @auth_headers
        end

        it 'returns all instances' do
          index_request
          expect(response).to have_http_status(200)
          expect(json_data.size).to eq model.all.count
        end
      end

      describe 'GET /admin/competition/:id' do
        context 'with valid id' do
          let(:show_request) do
            get "/admin/competitions/#{competition.id}",
                headers: @auth_headers
          end

          it 'returns competition with id provided' do
            show_request
            expect(response).to have_http_status(200)
            expect(json_data['id']).to eq(competition.id.to_s)
          end
        end

        context 'with invalid id' do
          let(:show_request) do
            get "/admin/competitions/0",
                headers: @auth_headers
          end

          it 'returns competition with id provided' do
            show_request
            expect(response).to have_http_status(404)
            expect(json).to eq "message" => "Couldn't find #{model} with 'id'=0"
          end
        end
      end

      describe 'POST /admin/competitions' do
        let(:start_date) { Time.now.strftime("%FT%T") }
        let(:end_date) { (Time.now + 20.days).strftime("%FT%T") }

        let(:post_request) do
          post '/admin/competitions',
               params: params,
               headers: @auth_headers
        end

        context 'valid data' do
          let(:attributes) do
            {
              'name': 'New Competition',
              'place': 'Kraków',
              'year': 2019,
              'start_date': start_date,
              'end_date': end_date

            }
          end

          it 'creates new competition' do\
            expect { post_request }.to change { Competition.count }.by(1)
            expect(response).to have_http_status(200)
            expect(json_attributes['name']).to eq('New Competition')
            expect(json_attributes['place']).to eq('Kraków')
            expect(json_attributes['year']).to eq(2019)
            expect(json_attributes['start_date']).to eq(start_date)
            expect(json_attributes['end_date']).to eq(end_date)
          end
        end

        context 'invalid data' do
          let(:attributes) do
            {
              'name': ''
            }
          end

          it 'does not create new competition' do
            expect { post_request }.to change { Competition.count }.by(0)
            expect(response).to have_http_status(422)
            expect(json).to eq(
              { "message" => "Negatywne sprawdzenie poprawności: Nazwa nie może być puste" }
            )
          end
        end

      end

      describe 'PATCH /admin/competition/:id' do
        let(:patch_request) do
          patch "/admin/competitions/#{competition.id}",
                params: params,
                headers: @auth_headers
        end

        context 'with valid data' do
          let(:attributes)  do
            { "name": "New name" }
          end

          it 'updates competition' do
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

          it 'does not update competition' do
            patch_request
            expect(response).to have_http_status(422)
            expect(json).to eq(
              { "message" => "Negatywne sprawdzenie poprawności: Nazwa nie może być puste" }
            )
          end
        end
      end

      describe 'DELETE /admin/competition/:id' do
        context 'valid params' do
          let(:delete_request) do
            delete "/admin/competitions/#{competition.id}",
                  headers: @auth_headers
          end

          it 'removes competition' do
            expect { delete_request }.to change { Competition.count }.by(-1)
            expect(response).to have_http_status(204)
          end
        end

        context 'invalid params' do
          let(:delete_request) do
            delete "/admin/competitions/0",
                  headers: @auth_headers
          end

          it 'does not remove competition' do
            expect { delete_request }.to change { Competition.count }.by(0)
            expect(response).to have_http_status(404)
            expect(json).to eq({"message"=>"Couldn't find #{model_string} with 'id'=0"})
          end
        end
      end
    end
  end
end
