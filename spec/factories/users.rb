require 'faker'

FactoryBot.define do
  factory :user do |u|
    u.username { Faker::Name.name }
    u.email { Faker::Internet.email }
    u.password { Faker::Internet.password(8) }
    u.role 'registered'
  end

  trait :admin do |u|
    u.role 'admin'
  end
end
