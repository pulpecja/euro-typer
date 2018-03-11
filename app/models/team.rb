class Team < ActiveRecord::Base
  has_many :matches, dependent: :destroy

  scope :ordered, -> { order :name }

  validates :name, presence: true, unless: ->(team){team.name_en.present?}

  mount_uploader :photo, PhotoUploader, mount_on: :photo_file_name
end
