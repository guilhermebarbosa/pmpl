require 'test_helper'

class OilsControllerTest < ActionController::TestCase
  setup do
    @oil = oils(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:oils)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create oil" do
    assert_difference('Oil.count') do
      post :create, :oil => @oil.attributes
    end

    assert_redirected_to oil_path(assigns(:oil))
  end

  test "should show oil" do
    get :show, :id => @oil.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @oil.to_param
    assert_response :success
  end

  test "should update oil" do
    put :update, :id => @oil.to_param, :oil => @oil.attributes
    assert_redirected_to oil_path(assigns(:oil))
  end

  test "should destroy oil" do
    assert_difference('Oil.count', -1) do
      delete :destroy, :id => @oil.to_param
    end

    assert_redirected_to oils_path
  end
end
