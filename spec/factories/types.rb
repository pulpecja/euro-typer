# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :type do
    association :user
    association :match
    first_score Faker::Number.digit
    second_score Faker::Number.digit
  end
end
