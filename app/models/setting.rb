class Setting < ApplicationRecord
  validates :name, :value, presence: true
end