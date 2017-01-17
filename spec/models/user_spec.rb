# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do

  it "has valid factory" do
    user = FactoryGirl.create(:user)
    expect(user).to be_valid
  end

  describe "Active record associations" do
    it { should have_one(:uploader).dependent(:destroy) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
  end

end
