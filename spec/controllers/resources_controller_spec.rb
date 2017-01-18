require 'rails_helper'

SAMPLE_UPLOADER_ID = 99

describe ResourcesController, type: :controller do
  let(:user) { create(:user) }

  # Test case for index action
  describe "GET #index" do
    it "populates an array of resources" do
      sign_in user
      resource = FactoryGirl.create(:resource)
      get :index
      expect(assigns[:resources]).to eq([resource])
    end

    it "renders the index view" do
      sign_in user
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET #show" do
    before(:all) { 10.times {
            resource = FactoryGirl.create(:resource)
            resource.uploader_id = SAMPLE_UPLOADER_ID
            }}
    it "searches resources with uploader_id" do
      get :show, id: SAMPLE_UPLOADER_ID
      assigns(:resources)
    end
  end
end
