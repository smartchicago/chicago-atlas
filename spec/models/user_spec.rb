# spec/models/contact_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do

  it "has valid factory" do
    user = FactoryGirl.create(:user)
    expect(user).to be_valid
  end

  describe "Associations" do
    #it { is_expected.to validate_presence_of(:name) }
    it { should have_one(:uploader).dependent(:destroy) }
  end
end
