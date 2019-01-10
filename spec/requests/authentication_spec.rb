# I've called it authentication_test_spec.rb and placed it in the spec/requests folder
require 'rails_helper'
include ActionController::RespondWith

describe "Whether access is ocurring properly", type: :request do
  let(:user) { create(:user) }

  context "general authentication via API, " do
    it "doesn't give you anything if you don't log in" do
      get '/groups'
      expect(response.status).to eq(401)
    end

    it "gives you an authentication code if you are an existing user and you satisfy the password" do
      login(user)
      expect(response.has_header?('access-token')).to eq(true)
    end

    it "gives you a status 200 on signing in " do
      login(user)
      expect(response.status).to eq(200)
    end

    it "gives you an authentication code if you are an existing user and you satisfy the password" do
      login(user)
      expect(response.has_header?('access-token')).to eq(true)
    end

    it "first get a token, then access a restricted page" do
      login(user)
      auth_params = get_auth_params_from_login_response_headers(response)
      get '/groups', headers: auth_params
      expect(response).to have_http_status(:success)
    end

    it "deny access to a restricted page with an incorrect token" do
      login(user)
      auth_params = get_auth_params_from_login_response_headers(response).tap do |h|
                      h.each do |k, v|
                        if k == 'access-token'
                          h[k] = '123'
                        end
                      end
                    end
      get '/groups', headers: auth_params
      expect(response).not_to have_http_status(:success)
    end
  end

  RSpec.shared_examples "use authentication tokens of different ages" do |token_age, http_status|      
    let(:vary_authentication_age) { token_age }

    it "uses the given parameter" do
      expect(vary_authentication_age(token_age)).to have_http_status(http_status)
    end

    def vary_authentication_age(token_age)
      login(user)
      auth_params = get_auth_params_from_login_response_headers(response)
      get '/groups', headers: auth_params
      expect(response).to have_http_status(:success)

      allow(Time).to receive(:now).and_return(Time.now + token_age)

      get '/groups', headers: auth_params
      return response
    end
  end

  context "test access tokens of varying ages" do
    include_examples "use authentication tokens of different ages", 2.days, :success
    include_examples "use authentication tokens of different ages", 5.years, :unauthorized
  end

  def get_auth_params_from_login_response_headers(response)
    client      = response.headers['client']
    token       = response.headers['access-token']
    expiry      = response.headers['expiry']
    token_type  = response.headers['token-type']
    uid         = response.headers['uid']

    auth_params =
      {
        'access-token' => token,
        'client' => client,
        'uid' => uid,
        'expiry' => expiry,
        'token_type' => token_type
      }
    auth_params
  end
end
