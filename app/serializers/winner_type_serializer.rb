class WinnerTypeSerializer
  include FastJsonapi::ObjectSerializer
  attributes :competition_id, :team_id, :user_id

  belongs_to :competition
  belongs_to :team
  belongs_to :user
end
