class TypeSerializer
  include FastJsonapi::ObjectSerializer
  attributes :bet, :first_score, :match_id, :second_score, :user_id

  belongs_to :match
  belongs_to :user
end
