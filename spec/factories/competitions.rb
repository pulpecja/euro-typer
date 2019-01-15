# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :competition do
    name { Faker::FunnyName }
    year { 2019 }
    place { Faker::Address.country }

    # after(:build) do |competition|
    #   competition.rounds << create(:round)
    # end
  end

  trait :no_rounds do |competition|
    competition.rounds []
  end
end
