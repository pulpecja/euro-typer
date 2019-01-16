# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :match do
    association :first_team, factory: :team
    association :second_team, factory: :team
    played { Faker::Time.forward(1, :evening) }
    round
  end
end
