# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :type do
    user_id 1
    match_id 1
    first_score ""
    second_score ""
  end
end
