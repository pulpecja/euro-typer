RSpec.shared_examples 'unauthorised_requests' do |options|
  before do
    @type = type
    @model = model.to_s
  end

  describe 'not logged in' do
    unauthorised_show_action
    unauthorised_index_action
    unauthorised_create_action
    unauthorised_update_action
    unauthorised_delete_action
  end
end

private
def unauthorised_show_action
  describe "GET /#{@type}/:id" do
    context 'with valid id' do
      let(:show_request) do
        get "/admin/#{@type}/#{team.id}"
      end

      it 'does not give access to page' do
        show_request
        expect(response).to have_http_status(403)
        expect(json).to eq "message" => "You are not authorized to access this page."
      end
    end

    context 'with invalid id' do
      let(:show_request) do
        get "/admin/#{@type}/0"
      end

      it 'does not give access to page' do
        show_request
        expect(response).to have_http_status(404)
        expect(json).to eq "message" => "Couldn't find #{@model} with 'id'=0"
      end
    end
  end
end

def unauthorised_index_action
  describe "GET /#{@type}" do
    let(:index_request) { get "/admin/#{@type}" }

    it 'does not give access to page' do
      index_request
      expect(response).to have_http_status(403)
      expect(json).to eq "message" => "You are not authorized to access this page."
    end
  end
end

def unauthorised_create_action
  describe "POST /#{@type}" do
    context 'valid data' do
      let(:attributes) do
        {
          name: "Nowy zespol",
          name_en: "New team"
        }
      end

      let(:post_request) do
        post "/admin/#{@type}",
              params: params
      end

      it 'does not give access to page' do
        expect { post_request }.to change { Team.count }.by(0)
        expect(response).to have_http_status(403)
        expect(json).to eq "message" => "You are not authorized to access this page."
      end
    end

    context 'invalid data' do
      let(:attributes) do
        {
          name: '',
          name_en: ''
        }
      end

      let(:post_request) do
        post "/admin/#{@type}",
            params: params,
            headers: @auth_headers
      end

      it 'does not give access to page' do
        expect { post_request }.to change { Team.count }.by(0)
        expect(response).to have_http_status(403)
        expect(json).to eq({ "message" => "You are not authorized to access this page." })
      end
    end
  end
end

def unauthorised_update_action
  describe 'PATCH /team/:id' do
    context 'with valid data' do
      let(:attributes) do
        {
          "name": 'New name'
        }
      end

      let(:patch_request) do
        patch "/admin/#{@type}/#{team.id}",
              params: params
      end

      it 'does not give access to page' do
        patch_request
        expect(response).to have_http_status(403)
        expect(json).to eq "message" => "You are not authorized to access this page."
      end
    end

    context 'with invalid data' do
      let(:attributes) do
        {
          "name": '',
          "name_en": ''
        }
      end

      let(:patch_request) do
        patch "/admin/#{@type}/#{team.id}",
            params: params,
            headers: @auth_headers
      end

      it 'does not give access to page' do
        patch_request
        expect(response).to have_http_status(403)
        expect(json).to eq "message" => "You are not authorized to access this page."
      end
    end
  end
end

def unauthorised_delete_action
  describe 'DELETE /team/:id' do
    let(:valid_params) do
      {
        id: team.id
      }
    end

    let(:delete_request) do
      delete "/admin/#{@type}/#{team.id}",
            params: valid_params,
            headers: @auth_headers
    end

    it 'removes team' do
      expect { delete_request }.to change { Team.count }.by(0)
      expect(response).to have_http_status(403)
      expect(json).to eq "message" => "You are not authorized to access this page."
    end
  end
end