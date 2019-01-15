class RoundSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :started_at, :stage

  has_many :matches
  belongs_to :competition
end
