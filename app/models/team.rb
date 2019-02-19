class Team < ApplicationRecord
  has_many :first_team, class_name: "Match", foreign_key: "first_team_id"
  has_many :second_team, class_name: "Match", foreign_key: "second_team_id"
  has_many :winner, class_name: "Competition", foreign_key: "winner_id"

  scope :ordered, -> { order :name }

  validates :name, presence: true, unless: ->(team){team.name_en.present?}
  mount_base64_uploader :photo, PhotoUploader, file_name: -> (_) { "photo" }
end
