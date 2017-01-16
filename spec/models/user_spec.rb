# spec/models/contact_spec.rb

require 'spec_helper'

RSpec.describe User, type: :model do
  it "works" do
    user = FactoryGirl.create(:user)
    expect(user).to be_valid
  end
end
