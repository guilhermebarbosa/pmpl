require 'test_helper'

class CarmodelsControllerTest < ActionController::TestCase
  setup do
    @carmodel = carmodels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:carmodels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create carmodel" do
    assert_difference('Carmodel.count') do
      post :create, :carmodel => @carmodel.attributes
    end

    assert_redirected_to carmodel_path(assigns(:carmodel))
  end

  test "should show carmodel" do
    get :show, :id => @carmodel.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @carmodel.to_param
    assert_response :success
  end

  test "should update carmodel" do
    put :update, :id => @carmodel.to_param, :carmodel => @carmodel.attributes
    assert_redirected_to carmodel_path(assigns(:carmodel))
  end

  test "should destroy carmodel" do
    assert_difference('Carmodel.count', -1) do
      delete :destroy, :id => @carmodel.to_param
    end

    assert_redirected_to carmodels_path
  end
end
