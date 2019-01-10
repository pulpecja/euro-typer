require 'faker'

FactoryBot.define do
  factory :user do
    username { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
  end

  trait :admin do
    role { 'admin' }
  end

  trait :registered do
    role { 'registered'}
  end

  trait :guest do
    role { 'guest' }
  end
end