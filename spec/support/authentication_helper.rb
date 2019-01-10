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
  end
end