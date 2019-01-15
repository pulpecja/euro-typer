RSpec.shared_examples 'unauthorized_requests' do |options|
  before do
    @instance = instance
    @model = model.to_s
    @type = type
  end

  unauthorised_show_action
  unauthorised_index_action
  unauthorised_create_action
  unauthorised_update_action
  unauthorised_delete_action
end

private
def unauthorised_show_action
  describe "GET /#{@type}/:id" do
    context 'with valid id' do
      let(:show_request) do
        get "/admin/#{@type}/#{@instance.id}",
            headers: auth_headers
      end

      it 'does not give access to page' do
        show_request
        expect(response).to have_http_status(403)
        expect(json).to eq "message" => "You are not authorized to access this page."
      end
    end

    context 'with invalid id' do
      let(:show_request) do
        get "/admin/#{@type}/0",
            headers: auth_headers
      end

      it 'does not give access to page' do
        show_request
        expect(response).to have_http_status(404)
        expect(json).to eq "message" => "Couldn't find #{model} with 'id'=0"
      end
    end
  end
end

def unauthorised_index_action
  describe "GET /#{@type}" do
    let(:index_request) do
      get "/admin/#{@type}",
          headers: auth_headers
    end

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
          name: "New name",
        }
      end

      let(:post_request) do
        post  "/admin/#{@type}",
              params: params,
              headers: auth_headers
      end

      it 'does not give access to page' do
        expect { post_request }.to change { model.count }.by(0)
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
             headers: auth_headers
      end

      it 'does not give access to page' do
        expect { post_request }.to change { model.count }.by(0)
        expect(response).to have_http_status(403)
        expect(json).to eq({ "message" => "You are not authorized to access this page." })
      end
    end
  end
end

def unauthorised_update_action
  describe "PATCH /#{@type}/:id" do
    context 'with valid data' do
      let(:attributes) do
        {
          "name": 'New name'
        }
      end

      let(:patch_request) do
        patch "/admin/#{@type}/#{@instance.id}",
              params: params,
              headers: auth_headers
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
        patch "/admin/#{@type}/#{@instance.id}",
              params: params,
              headers: auth_headers
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
  describe "DELETE /#{@type}/:id" do
    let(:delete_request) do
      delete "/admin/#{@type}/#{@instance.id}",
             headers: auth_headers
    end

    it "removes #{@type.to_s}" do
      expect { delete_request }.to change { model.count }.by(0)
      expect(response).to have_http_status(403)
      expect(json).to eq "message" => "You are not authorized to access this page."
    end
  end
end