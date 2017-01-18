# spec/factories/uploader.rb

FactoryGirl.define do
  factory :uploader do
    user
    name { "test.xlsx" }
    path { "downloads/test.xml" }
    status { Uploader.statuses[:uploaded] }
    total_row 5
    current_row 0
  end
end
