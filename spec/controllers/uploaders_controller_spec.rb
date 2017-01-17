require 'rails_helper'

describe UploadersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #index' do
    it "populates an array of uploaders" do
      sign_in user
      uploader = FactoryGirl.create(:uploader)
      get :index
      expect(assigns(:uploaders)).to eq([uploader])
    end

    it "renders the :index view" do
      sign_in user
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "#upload" do
    it "should upload file and run parser" do
      sign_in user
      post :create, uploader: {path: fixture_file_upload('test.xlsx')}

      expect(user.uploaders.count).to be(1)
      uploader = user.uploaders.last
      expect(uploader.completed?).to be_truthy
      expect(uploader.total_row).to be(5)
      expect(uploader.current_row).to be(5)
    end

    it "should not run parser if invalid file type" do
    end
  end
end
