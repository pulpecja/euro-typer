class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :created_at,
             :deleted_at,
             :email,        
             :remember_created_at, 
             :role,
             :take_part,
             :username
  attribute :photo do |object|
    object.reload

    { "url" => object.photo.url,
      "mini" => {
        "url" => object.photo.mini.url
      },
      "thumb" => {
        "url" => object.photo.thumb.url
      },
      "medium" => {
        "url" => object.photo.thumb.url
      }
    }
  end
  has_many :types
  has_many :groups
  has_many :competitions
end
