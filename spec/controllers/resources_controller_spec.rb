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
      expect(assigns[:resources].last).to eq(resource)
    end

    it "renders the index view" do
      sign_in user
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET #show" do
    it "searches resources with uploader_id" do
      sign_in user
      uploader = FactoryGirl.create(:uploader_with_resources, resources_count: 10)
      get :show, id: uploader
      expect(assigns(:resources)).to eq(uploader.resources)
    end

    it "renders the show view" do
      sign_in user
      uploader = FactoryGirl.create(:uploader_with_resources, resources_count: 10)
      get :show, id: uploader
      expect(assigns(:resources)).to render_template("show")
    end

    # test case for pagination
    it "doesn't show second page" do
      sign_in user
      uploader =  FactoryGirl.create(:uploader_with_resources, resources_count: 9)
      get :show, {id: uploader, page: 2}
      expect(assigns(:resources).length).to be(0)
    end

    it "should show second page" do
      sign_in user
      uploader = FactoryGirl.create(:uploader_with_resources, resources_count: 11)
      get :show, {id: uploader, page: 2}
      expect(assigns(:resources).length).to be(1)
    end
  end
end
