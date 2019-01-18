FactoryBot.define do
  factory :setting do
    name { Faker::Music.band }
    value { Faker::Music.album }
  end

  trait :end_of_voting do
    name { 'end_of_voting' }
    value { '1' }
  end
end