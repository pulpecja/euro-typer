class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email, :username, :role, :photo

  has_many :types
  has_many :groups
  has_many :competitions
end
