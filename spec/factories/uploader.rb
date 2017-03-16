# spec/factories/uploader.rb

FactoryGirl.define do
  factory :uploader do
    user
    name { "test.xlsx" }
    path { "downloads/test.xml" }
    status { Uploader.statuses[:uploaded] }
    indicator_id { 1 }
    total_row 5
    current_row 0

    factory :uploader_with_resources do
      transient do
        resources_count 10
      end

      after(:create) do |uploader, evaluator|
        create_list(:resource, evaluator.resources_count, uploader: uploader)
      end
    end
  end
end
