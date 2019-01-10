# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :team do
    name { 'Polska nazwa' }
    name_en { Faker::Address.country }
  end
end
