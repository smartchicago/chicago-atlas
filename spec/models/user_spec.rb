# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do
  describe "factory validation check" do
    context "valid factory" do
      it "should be valid factory" do
        expect(FactoryGirl.create(:user)).to be_valid
      end
    end

    context "invalid factory" do
      it "is invalid without name" do
        expect(FactoryGirl.build(:user, name: nil)).not_to be_valid
      end

      it "is invalid without email" do
        expect(FactoryGirl.build(:user, email: nil)).not_to be_valid
      end
    end
  end

  describe "ActiveRecord associations" do
    it { should have_many(:uploaders).dependent(:destroy) }
  end

  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
  end
end
