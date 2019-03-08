class TeamSerializer
  include FastJsonapi::ObjectSerializer
  attributes :abbreviation, :flag, :name, :name_en, :photo
 
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

  has_many :first_team
  has_many :second_team
  has_many :winner
end
