# spec/models/uploader_spec.rb

require 'rails_helper'

RSpec.describe Uploader, type: :model do

  it "has valid factory" do
    uploader = FactoryGirl.create(:uploader)
    expect(uploader).to be_valid
  end

  describe "Active record associations" do
    it { should belong_to(:user) }
  end

  describe "Validations" do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:name) }

    it "should allow valid values in status" do
      Uploader::statuses.keys.each do |v|
        should allow_value(v).for(:status)
      end
    end
  end

  describe 'Enums' do
    it { should define_enum_for(:status) }

    context 'status enum' do
      [:uploaded, :processing, :completed, :failed].each do |value|
        it { should allow_value(value).for(:status) }
      end

      it 'does not allow invalid value' do
        expect { should allow_value(:invalid).for(:status) }.to raise_error(ArgumentError)
      end
    end
  end
end
