module AuthenticationHelper
  def login(user)
    email = user.email
    pass = user.password

    post '/auth/sign_in',
      params:
      {
        email: email,
        password: pass
      }.to_json,
      headers: {
        'CONTENT_TYPE' => 'application/json',
        'ACCEPT' => 'application/json'
      }

      response
  end

  def get_auth_headers(response_data)
    {
      "access-token" => response_data['access-token'],
      "token-type" => response_data['token-type'],
      "client" => response_data['client'],
      "expiry" => response_data['expiry'],
      "uid" => response_data['uid']
    }
  end
end