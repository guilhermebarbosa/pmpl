require 'test_helper'

class VehicleHistoricsControllerTest < ActionController::TestCase
  setup do
    @vehicle_historic = vehicle_historics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vehicle_historics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vehicle_historic" do
    assert_difference('VehicleHistoric.count') do
      post :create, :vehicle_historic => @vehicle_historic.attributes
    end

    assert_redirected_to vehicle_historic_path(assigns(:vehicle_historic))
  end

  test "should show vehicle_historic" do
    get :show, :id => @vehicle_historic.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @vehicle_historic.to_param
    assert_response :success
  end

  test "should update vehicle_historic" do
    put :update, :id => @vehicle_historic.to_param, :vehicle_historic => @vehicle_historic.attributes
    assert_redirected_to vehicle_historic_path(assigns(:vehicle_historic))
  end

  test "should destroy vehicle_historic" do
    assert_difference('VehicleHistoric.count', -1) do
      delete :destroy, :id => @vehicle_historic.to_param
    end

    assert_redirected_to vehicle_historics_path
  end
end
