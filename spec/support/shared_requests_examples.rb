RSpec.shared_examples 'not_logged_in_requests' do |options|
  let(:status_code) { 401 }
  let(:message) { {"errors"=>["Aby kontynuować musisz się zalogować."]} }

  before do
    @instance = instance
    @model = model.to_s
    @type = type
  end

  not_logged_in_show_action
  not_logged_in_index_action
end

RSpec.shared_examples 'unauthorized_requests' do |options|
  let(:status_code) { 403 }
  let(:message) { {"message" => "You are not authorized to access this page."} }

  before do
    @instance = instance
    @model = model.to_s
    @type = type
  end

  unauthorized_show_action
  unauthorized_index_action
end

RSpec.shared_examples 'admin_namespace_not_logged_in_requests' do |options|
  let(:status_code) { 401 }
  let(:message) { {"errors"=>["Aby kontynuować musisz się zalogować."]} }

  before do
    @instance = instance
    @model = model.to_s
    @type = type
  end

  namespace = '/admin'

  not_logged_in_show_action(namespace)
  not_logged_in_index_action(namespace)
  not_logged_in_create_action(namespace)
  not_logged_in_update_action(namespace)
  not_logged_in_delete_action(namespace)
end

RSpec.shared_examples 'admin_namespace_unauthorized_requests' do |options|
  let(:status_code) { 403 }
  let(:message) { {"message" => "You are not authorized to access this page."} }

  before do
    @instance = instance
    @model = model.to_s
    @type = type
  end

  namespace = '/admin'

  unauthorized_show_action(namespace)
  unauthorized_index_action(namespace)
  unauthorized_create_action(namespace)
  unauthorized_update_action(namespace)
  unauthorized_delete_action(namespace)
end

private
# logged in, not authorized
def unauthorized_show_action(namespace = '')
  describe "GET #show" do
    context 'with valid id' do
      let(:show_request) do
        get "#{namespace}/#{@type}/#{@instance.id}",
            headers: auth_headers
      end

      it 'does not give access to page' do
        show_request
        expect(response).to have_http_status(status_code)
        expect(json).to eq message
      end
    end

    context 'with invalid id' do
      let(:message) { { "message" => "Couldn't find #{@model} with 'id'=0" } }
      let(:status_code) { 404 }

      let(:show_request) do
        get "#{namespace}/#{@type}/0",
            headers: auth_headers
      end

      it 'does not give access to page' do
        show_request
        expect(response).to have_http_status(status_code)
        expect(json).to eq message
      end
    end
  end
end

def unauthorized_index_action(namespace = '')
  describe "GET #index" do
    let(:index_request) do
      get "#{namespace}/#{@type}",
          headers: auth_headers
    end

    it 'does not give access to page' do
      index_request
      expect(response).to have_http_status(status_code)
      expect(json).to eq message
    end
  end
end

def unauthorized_create_action(namespace = '')
  describe "POST #create" do
    context 'valid data' do
      let(:attributes) do
        {
          name: "New name",
        }
      end

      let(:post_request) do
        post  "#{namespace}/#{@type}",
              params: params,
              headers: auth_headers
      end

      it 'does not give access to page' do
        expect { post_request }.to change { model.count }.by(0)
        expect(response).to have_http_status(status_code)
        expect(json).to eq message
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
        post "#{namespace}/#{@type}",
             params: params,
             headers: auth_headers
      end

      it 'does not give access to page' do
        expect { post_request }.to change { model.count }.by(0)
        expect(response).to have_http_status(status_code)
        expect(json).to eq message
      end
    end
  end
end

def unauthorized_update_action(namespace = '')
  describe "PATCH #update" do
    context 'with valid data' do
      let(:attributes) do
        {
          "name": 'New name'
        }
      end

      let(:patch_request) do
        patch "#{namespace}/#{@type}/#{@instance.id}",
              params: params,
              headers: auth_headers
      end

      it 'does not give access to page' do
        patch_request
        expect(response).to have_http_status(status_code)
        expect(json).to eq message
      end
    end

    context 'with invalid data' do
      let(:attributes) do
        {
          "name": ''
        }
      end

      let(:patch_request) do
        patch "#{namespace}/#{@type}/#{@instance.id}",
              params: params,
              headers: auth_headers
      end

      it 'does not give access to page' do
        patch_request
        expect(response).to have_http_status(status_code)
        expect(json).to eq message
      end
    end
  end
end

def unauthorized_delete_action(namespace = '')
  describe "DELETE #destroy" do
    let(:delete_request) do
      delete "#{namespace}/#{@type}/#{@instance.id}",
             headers: auth_headers
    end

    it "removes #{@type.to_s}" do
      expect { delete_request }.to change { model.count }.by(0)
      expect(response).to have_http_status(403)
      expect(json).to eq "message" => "You are not authorized to access this page."
    end
  end
end

# not logged in
def not_logged_in_show_action(namespace = '')
  describe "GET #show" do
    context 'with valid id' do
      let(:show_request) do
        get "#{namespace}/#{@type}/#{@instance.id}",
            headers: auth_headers
      end

      it 'does not give access to page' do
        show_request
        expect(response).to have_http_status(status_code)
        expect(json).to eq message
      end
    end

    context 'with invalid id' do
      let(:show_request) do
        get "#{namespace}/#{@type}/0",
            headers: auth_headers
      end

      it 'does not give access to page' do
        show_request
        expect(response).to have_http_status(status_code)
        expect(json).to eq message
      end
    end
  end
end

def not_logged_in_index_action(namespace = '')
  describe "GET #index" do
    let(:index_request) do
      get "#{namespace}/#{@type}",
          headers: auth_headers
    end

    it 'does not give access to page' do
      index_request
      expect(response).to have_http_status(status_code)
      expect(json).to eq message
    end
  end
end

def not_logged_in_create_action(namespace = '')
  describe "POST #create" do
    context 'valid data' do
      let(:attributes) do
        {
          name: "New name",
        }
      end

      let(:post_request) do
        post  "#{namespace}/#{@type}",
              params: params,
              headers: auth_headers
      end

      it 'does not give access to page' do
        expect { post_request }.to change { model.count }.by(0)
        expect(response).to have_http_status(status_code)
        expect(json).to eq message
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
        post "#{namespace}/#{@type}",
             params: params,
             headers: auth_headers
      end

      it 'does not give access to page' do
        expect { post_request }.to change { model.count }.by(0)
        expect(response).to have_http_status(status_code)
        expect(json).to eq message
      end
    end
  end
end

def not_logged_in_update_action(namespace = '')
  describe "PATCH #update" do
    context 'with valid data' do
      let(:attributes) do
        {
          "name": 'New name'
        }
      end

      let(:patch_request) do
        patch "#{namespace}/#{@type}/#{@instance.id}",
              params: params,
              headers: auth_headers
      end

      it 'does not give access to page' do
        patch_request
        expect(response).to have_http_status(status_code)
        expect(json).to eq message
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
        patch "#{namespace}/#{@type}/#{@instance.id}",
              params: params,
              headers: auth_headers
      end

      it 'does not give access to page' do
        patch_request
        expect(response).to have_http_status(status_code)
        expect(json).to eq message
      end
    end
  end
end

def not_logged_in_delete_action(namespace = '')
  describe "DELETE #destroy" do
    let(:delete_request) do
      delete "#{namespace}/#{@type}/#{@instance.id}",
             headers: auth_headers
    end

    it "removes #{@type.to_s}" do
      expect { delete_request }.to change { model.count }.by(0)
      expect(response).to have_http_status(status_code)
      expect(json).to eq message
    end
  end
end