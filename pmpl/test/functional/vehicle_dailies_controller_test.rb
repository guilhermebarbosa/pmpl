require 'test_helper'

class VehicleDailiesControllerTest < ActionController::TestCase
  setup do
    @vehicle_daily = vehicle_dailies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vehicle_dailies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vehicle_daily" do
    assert_difference('VehicleDaily.count') do
      post :create, :vehicle_daily => @vehicle_daily.attributes
    end

    assert_redirected_to vehicle_daily_path(assigns(:vehicle_daily))
  end

  test "should show vehicle_daily" do
    get :show, :id => @vehicle_daily.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @vehicle_daily.to_param
    assert_response :success
  end

  test "should update vehicle_daily" do
    put :update, :id => @vehicle_daily.to_param, :vehicle_daily => @vehicle_daily.attributes
    assert_redirected_to vehicle_daily_path(assigns(:vehicle_daily))
  end

  test "should destroy vehicle_daily" do
    assert_difference('VehicleDaily.count', -1) do
      delete :destroy, :id => @vehicle_daily.to_param
    end

    assert_redirected_to vehicle_dailies_path
  end
end
