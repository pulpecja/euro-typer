# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :winner_type do
    association :competition, factory: :competition
    association :team, factory: :team
    association :user, factory: :user
  end
end
