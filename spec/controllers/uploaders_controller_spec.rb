require 'rails_helper'

###########################################################################################
XML_FILE_TYPE       =   'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
XML_TEST_FILE_NAME  =   'test.xlsx'
INVALID_FILE_NAME   =   'invalid.jpg'
INVALID_FILE_TYPE   =   'jpeg'
###########################################################################################

describe UploadersController, type: :controller do
  let(:user) { create(:user) }

  #Test case for index action
  describe 'GET #index' do
    it "populates an array of uploaders" do
      sign_in user
      uploader = FactoryGirl.create(:uploader)
      get :index
      expect(assigns(:uploaders).last).to eq(uploader)
    end

    it "renders the :index view" do
      sign_in user
      get :index
      expect(response).to render_template("index")
    end
  end

  #Test case for show action
  describe "GET #show" do
    it "assigns the requested uploader to @uploader" do
      sign_in user
      uploader = FactoryGirl.create(:uploader)
      get :show, id: uploader
      expect(assigns(:uploader)).to eq(Uploader.last)
    end

    it "renders the #show view" do
      sign_in user
      get :show, id: FactoryGirl.create(:uploader)
      expect(response).to render_template("show")
    end
  end

  #Test case for new action
  describe "GET #new" do
    it "creates new uploader" do
      sign_in user
      get :new
      expect(assigns(:uploader).name).to eq(nil)
    end

    it "renders the #new view" do
      sign_in user
      get :new
      expect(response).to render_template("new")
    end
  end

  #Test case for create action
  describe "POST #create" do
    it "creates a new uploader" do
      sign_in user
      expect{ post :create, uploader: { path: fixture_file_upload(XML_TEST_FILE_NAME, XML_FILE_TYPE) } }.to change(Uploader, :count).by(1)
    end

    it "redirects to the new uploader" do
      sign_in user
      post :create, uploader: { path: fixture_file_upload(XML_TEST_FILE_NAME, XML_FILE_TYPE) }
      expect(response).to redirect_to root_path
    end

    it "does not save the new uploader" do
      sign_in user
      post :create, uploader: { path: fixture_file_upload(INVALID_FILE_NAME, INVALID_FILE_TYPE) }
      expect{ response }.to_not change(Uploader, :count)
    end

    it "re-renders the new method" do
      sign_in user
      post :create, uploader: { path: fixture_file_upload(INVALID_FILE_NAME, INVALID_FILE_TYPE) }
      expect(response).to render_template(nil)
    end

    #background job test case
    describe "#upload" do
      it "should upload file and run parser" do
        sign_in user
        post :create, uploader: {path: fixture_file_upload(XML_TEST_FILE_NAME, XML_FILE_TYPE)}

        expect(user.uploaders.count).to be(1)
        uploader = user.uploaders.last
        expect(uploader.completed?).to be_truthy
        expect(uploader.total_row).to be(4)
        expect(uploader.current_row).to be(4)
      end

      it "should not run parser if invalid file type" do
        sign_in user
        post :create, uploader: { path: fixture_file_upload(INVALID_FILE_NAME, INVALID_FILE_TYPE) }
        expect{ response }.to_not change(Uploader, :count)
      end
    end
  end

  # Test case for delete acton
  describe "DELETE destroy" do
    before :each do
      @uploader = FactoryGirl.create(:uploader)
    end

    it "deletes the uploader" do
      sign_in user
      expect{
        delete :destroy, id: @uploader
      }.to change(Uploader, :count).by(-1)
    end
  end
end
