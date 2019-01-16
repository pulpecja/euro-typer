class GroupSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :token, :owner_id
  belongs_to :owner, serializer: UserSerializer
  has_many :users
  has_many :competitions
end
