# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :competition do
    name "Mistrzostwa Świata"
    year 2018
    place "Rosja"

    after(:build) do |competition|
      competition.rounds << create(:round)
    end
  end

  trait :no_rounds do |competition|
    competition.rounds []
  end
end
