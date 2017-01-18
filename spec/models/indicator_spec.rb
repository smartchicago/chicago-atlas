require 'rails_helper'

RSpec.describe Indicator, type: :model do
  describe "factory validation check" do
    context "valid factory" do
      it "should be valid factory" do
        expect(FactoryGirl.create(:indicator)).to be_valid
      end
    end

    context "invalid factory" do
      it "is invalid without name" do
        expect(FactoryGirl.build(:indicator, name: nil)).not_to be_valid
      end
    end
  end

  describe "ActiveRecord associations" do
    it { should have_many(:resources) }
  end

  describe "Validations" do
    it { should validate_presence_of(:name) }
  end
end
