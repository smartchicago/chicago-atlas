require 'test_helper'

class SpreadSheetsControllerTest < ActionController::TestCase
  setup do
    @spread_sheet = spread_sheets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:spread_sheets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create spread_sheet" do
    assert_difference('SpreadSheet.count') do
      post :create, spread_sheet: { name: @spread_sheet.name }
    end

    assert_redirected_to spread_sheet_path(assigns(:spread_sheet))
  end

  test "should show spread_sheet" do
    get :show, id: @spread_sheet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @spread_sheet
    assert_response :success
  end

  test "should update spread_sheet" do
    patch :update, id: @spread_sheet, spread_sheet: { name: @spread_sheet.name }
    assert_redirected_to spread_sheet_path(assigns(:spread_sheet))
  end

  test "should destroy spread_sheet" do
    assert_difference('SpreadSheet.count', -1) do
      delete :destroy, id: @spread_sheet
    end

    assert_redirected_to spread_sheets_path
  end
end
