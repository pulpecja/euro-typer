class CompetitionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :year, :place, :winner_id

  attribute :start_date do |object|
    object.start_date.strftime("%FT%T") if object.start_date
  end

  attribute :end_date do |object|
    object.end_date.strftime("%FT%T") if object.end_date
  end

  has_many :groups
  has_many :rounds
  has_many :users
  has_one :winner
end
