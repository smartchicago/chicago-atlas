# spec/factories/uploader.rb

FactoryGirl.define do
  factory :uploader do
    name { "test.xlsx" }
    user
    status { Uploader.statuses[:uploaded] }
    total_row 5
    current_row 0
  end
end
