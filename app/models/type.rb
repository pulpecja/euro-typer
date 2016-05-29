class Type < ActiveRecord::Base
  belongs_to :match
  belongs_to :user

  scope :by_user, ->(current_user) { where(user_id: current_user.id) }
end
