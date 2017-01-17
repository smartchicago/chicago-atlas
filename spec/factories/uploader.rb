# spec/factories/uploader.rb

FactoryGirl.define do
  factory :uploader do
    created_at { generate(:created_at) }
    updated_at { generate(:updated_at) }
    # path "https://chicagoha.s3.amazonaws.com/uploads/uploader/path/1/Low_Birth_Weight.xlsx"
    status { generate(:status) }
    name { "Low_Birth_Weight.xlsx" }
    total_row { generate(:total_row) }
    current_row { generate(:current_row) }

    association :user, factory: :user
  end

  sequence :created_at do |n|
    DateTime.new
  end

  sequence :updated_at do |n|
    DateTime.new
  end

  sequence :status do |n|
    0
  end

  sequence :total_row do |n|
    243
  end

  sequence :current_row do |n|
    0
  end
end
