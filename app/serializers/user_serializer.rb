class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :created_at,
             :deleted_at,
             :email,        
             :photo, 
             :remember_created_at, 
             :role,
             :take_part,
             :username

  has_many :types
  has_many :groups
  has_many :competitions
end
