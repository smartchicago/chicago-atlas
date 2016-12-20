require 'test_helper'

class UploadersControllerTest < ActionController::TestCase
  setup do
    @uploader = uploaders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:uploaders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create uploader" do
    assert_difference('Uploader.count') do
      post :create, uploader: {  }
    end

    assert_redirected_to uploader_path(assigns(:uploader))
  end

  test "should show uploader" do
    get :show, id: @uploader
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @uploader
    assert_response :success
  end

  test "should update uploader" do
    patch :update, id: @uploader, uploader: {  }
    assert_redirected_to uploader_path(assigns(:uploader))
  end

  test "should destroy uploader" do
    assert_difference('Uploader.count', -1) do
      delete :destroy, id: @uploader
    end

    assert_redirected_to uploaders_path
  end
end
