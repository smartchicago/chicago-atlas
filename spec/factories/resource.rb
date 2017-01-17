# spec/factories/resource.rb

FactoryGirl.define do
  factory :resource do
    association :uploader, factory: :uploader
  end
end
