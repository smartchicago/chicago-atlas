# spec/factories/uploader.rb

FactoryGirl.define do
  factory :uploader do
    status { Uploader.statuses[:uploaded] }
    total_row 0
    current_row 0
  end
end
