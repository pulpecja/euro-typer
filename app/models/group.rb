class Group < ApplicationRecord
  include Tokenable

  has_many :groups_users,        dependent: :destroy
  has_many :competitions_groups, dependent: :destroy
  has_many :users,        -> { distinct }, through: :groups_users
  has_many :competitions, -> { distinct }, through: :competitions_groups

  belongs_to :owner, class_name: 'User'

  validates_presence_of :owner_id, :name
end
