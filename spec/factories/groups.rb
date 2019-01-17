FactoryBot.define do
  factory :group do
    name { Faker::LordOfTheRings.character }
    token { "MyString" }
    association :owner, factory: :user
  end
end
