# spec/factories/user.rb

FactoryGirl.define do
  factory :user do
    name { generate(:name) }
    email { generate(:email) }
    password {generate(:password) }
    confirmed_at { generate(:confirmed_at) }
  end

  sequence :email do |n|
    "user_#{n}@parrolabs.com"
  end

  sequence :name do |n|
    Faker::Name.name
  end

  sequence :password do |n|
    "1234567890"
  end

  sequence :confirmed_at do |n|
    DateTime.new
  end
end
