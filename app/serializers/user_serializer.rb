class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :created_at,
             :deleted_at,
             :email,
             :remember_created_at,
             :role,
             :take_part,
             :username,
             :photo

  has_many :types
  has_many :groups
  has_many :competitions
end
