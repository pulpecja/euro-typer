class TeamSerializer
  include FastJsonapi::ObjectSerializer
  attributes :abbreviation, :flag, :name, :name_en, :photo
  
  has_many :first_team
  has_many :second_team
  has_many :winner
end
