require 'faker'

FactoryBot.define do
  factory :user do
    username { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    role { 'registered' }
  end

  trait :admin do
    role { 'admin' }
  end
end