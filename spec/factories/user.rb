# spec/factories/user.rb

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { '12345678' }
    password_confirmation { '12345678' }
    confirmed_at { Date.today }
  end
end
