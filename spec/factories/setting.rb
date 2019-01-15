FactoryBot.define do
  factory :setting do
    name { Faker::Music.band }
    value { Faker::Music.album }
  end
end