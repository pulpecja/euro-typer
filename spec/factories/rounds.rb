# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :round do
    name { Faker::DragonBall.character }
    competition
    started_at Time.now.strftime("%FT%T") 
  end
end
