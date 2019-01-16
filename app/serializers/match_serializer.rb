class MatchSerializer
  include FastJsonapi::ObjectSerializer
  attributes  :first_team_id,
              :second_team_id,
              :first_score,
              :second_score

  attribute :played do |object|
    object.played.strftime("%FT%T") if object.played
  end

  belongs_to :first_team, serializer: TeamSerializer
  belongs_to :second_team, serializer: TeamSerializer
  belongs_to :round
  has_many :types
end
