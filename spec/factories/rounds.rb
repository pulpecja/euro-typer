# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :round do
    name { Faker::DragonBall.character }
    competition
  end
end
