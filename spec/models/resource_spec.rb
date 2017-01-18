require 'rails_helper'

RSpec.describe Resource, type: :model do
  describe "factory vaildation check" do
    context "valid factory" do
      it "has a valid factory" do
        expect(FactoryGirl.create(:resource)).to be_valid
      end
    end

    context "invalid factory" do
      it "is invalid without uploader" do
        expect(FactoryGirl.build(:resource, uploader: nil)).not_to be_valid
      end

      it "is invalid without category" do
        expect(FactoryGirl.build(:resource, category: nil)).not_to be_valid
      end

      it "is invalid without indicator" do
        expect(FactoryGirl.build(:resource, indicator: nil)).not_to be_valid
      end

      it "is invalid without geo_group" do
        expect(FactoryGirl.build(:resource, geo_group: nil)).not_to be_valid
      end

      it "is invalid without demo_group" do
        expect(FactoryGirl.build(:resource, demo_group: nil)).not_to be_valid
      end
    end
  end

  describe "Active record assocations" do
    it { should belong_to(:uploader) }
    it { should belong_to(:category) }
    it { should belong_to(:demo_group) }
    it { should belong_to(:geo_group) }
    it { should belong_to(:indicator) }
  end

  describe "Validations" do
    it { should validate_presence_of(:uploader_id) }
    it { should validate_presence_of(:category_id) }
    it { should validate_presence_of(:indicator_id) }
    it { should validate_presence_of(:geo_group_id) }
    it { should validate_presence_of(:demo_group_id) }
  end
end
